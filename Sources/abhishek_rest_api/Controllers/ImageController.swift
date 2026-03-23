import Vapor
import Fluent
import VaporToOpenAPI

struct ImageController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let images = routes.grouped("images")
        images.get(use: index)
            .openAPI(tags: "Images", summary: "Fetch all images")
        images.post(use: create)
            .openAPI(tags: "Images", summary: "Create an image record")
        images.group(":imageID") { image in
            image.get(use: show)
                .openAPI(tags: "Images", summary: "Fetch an image by ID")
            image.put(use: update)
                .openAPI(tags: "Images", summary: "Update an image record")
            image.delete(use: delete)
                .openAPI(tags: "Images", summary: "Delete an image record")
        }
    }

    // GET /images
    @Sendable
    func index(req: Request) async throws -> Page<ImageModel> {
        try await ImageModel.query(on: req.db).paginate(for: req)
    }

    // POST /images
    @Sendable
    func create(req: Request) async throws -> ImageModel {
        let image = try req.content.decode(ImageModel.self)
        try await image.save(on: req.db)
        return image
    }

    // GET /images/:imageID
    @Sendable
    func show(req: Request) async throws -> ImageModel {
        guard let image = try await ImageModel.find(req.parameters.get("imageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return image
    }

    // PUT /images/:imageID
    @Sendable
    func update(req: Request) async throws -> ImageModel {
        guard let image = try await ImageModel.find(req.parameters.get("imageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedImage = try req.content.decode(ImageModel.self)
        image.name = updatedImage.name
        image.url = updatedImage.url
        image.type = updatedImage.type
        try await image.save(on: req.db)
        return image
    }

    // DELETE /images/:imageID
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let image = try await ImageModel.find(req.parameters.get("imageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await image.delete(on: req.db)
        return .noContent
    }
}
