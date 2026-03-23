import Vapor
import Fluent
import VaporToOpenAPI

struct MovieController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let movies = routes.grouped("movies")
        movies.get(use: index)
            .openAPI(tags: "Movies", summary: "Fetch all movies")
        movies.post(use: create)
            .openAPI(tags: "Movies", summary: "Create a movie")
        movies.post("sync", use: sync)
            .openAPI(tags: "Movies", summary: "Sync movies from external API")
        movies.group(":movieID") { movie in
            movie.get(use: show)
                .openAPI(tags: "Movies", summary: "Fetch a movie by ID")
            movie.put(use: update)
                .openAPI(tags: "Movies", summary: "Update a movie")
            movie.delete(use: delete)
                .openAPI(tags: "Movies", summary: "Delete a movie")
        }
    }

    // GET /movies
    @Sendable
    func index(req: Request) async throws -> [MovieModel] {
        try await MovieModel.query(on: req.db).all()
    }

    // POST /movies
    @Sendable
    func create(req: Request) async throws -> MovieModel {
        let movie = try req.content.decode(MovieModel.self)
        try await movie.save(on: req.db)
        return movie
    }

    // GET /movies/:movieID
    @Sendable
    func show(req: Request) async throws -> MovieModel {
        guard let movie = try await MovieModel.find(req.parameters.get("movieID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return movie
    }

    // PUT /movies/:movieID
    @Sendable
    func update(req: Request) async throws -> MovieModel {
        guard let movie = try await MovieModel.find(req.parameters.get("movieID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedMovie = try req.content.decode(MovieModel.self)
        movie.title = updatedMovie.title
        movie.genre = updatedMovie.genre
        movie.year = updatedMovie.year
        movie.director = updatedMovie.director
        movie.overview = updatedMovie.overview
        movie.posterPath = updatedMovie.posterPath
        try await movie.save(on: req.db)
        return movie
    }

    // DELETE /movies/:movieID
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let movie = try await MovieModel.find(req.parameters.get("movieID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await movie.delete(on: req.db)
        return .noContent
    }
    // POST /movies/sync
    @Sendable
    func sync(req: Request) async throws -> HTTPStatus {
        // Check if movies already exist to skip redundant syncs
        let count = try await MovieModel.query(on: req.db).count()
        if count > 0 {
            req.logger.info("Movies already exist (\(count)). Skipping automatic sync.")
            return .ok
        }

        req.logger.info("Syncing movies from external API...")
        let start = Date()
        let externalUrl = URI(string: "https://jsonfakery.com/movies/paginated")
        let response = try await req.client.get(externalUrl)
        
        let movieData = try response.content.decode(ExternalMovieResponse.self)
        
        let moviesToSave = movieData.data.map { extMovie in
            let year = extractYear(from: extMovie.release_date)
            return MovieModel(
                title: extMovie.original_title,
                genre: "Unknown",
                year: year,
                director: "Unknown",
                overview: extMovie.overview,
                posterPath: extMovie.poster_path
            )
        }
        
        // Batch save all movies at once for much better performance
        try await moviesToSave.create(on: req.db)
        let elapsed = Date().timeIntervalSince(start)
        req.logger.info("Successfully synced \(moviesToSave.count) movies in \(String(format: "%.2f", elapsed))s.")
        
        return .ok
    }

    private func extractYear(from dateString: String) -> Int {
        // Format: "Mon, 03/19/2012"
        let components = dateString.components(separatedBy: "/")
        if components.count == 3 {
            if let year = Int(components[2]) {
                return year
            }
        }
        return 0
    }
}

struct ExternalMovieResponse: Content {
    let data: [ExternalMovie]
}

struct ExternalMovie: Content {
    let original_title: String
    let release_date: String
    let overview: String
    let poster_path: String
}
