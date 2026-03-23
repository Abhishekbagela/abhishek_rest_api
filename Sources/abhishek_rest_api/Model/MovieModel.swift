import Foundation
import Vapor
import FluentKit

final class MovieModel: Model, Content {
    static let schema = "movies"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "genre")
    var genre: String
    
    @Field(key: "year")
    var year: Int
    
    @Field(key: "director")
    var director: String

    @Field(key: "overview")
    var overview: String?

    @Field(key: "poster_path")
    var posterPath: String?
    
    init() {}
    
    init(id: UUID? = nil, title: String, genre: String, year: Int, director: String, overview: String? = nil, posterPath: String? = nil) {
        self.id = id
        self.title = title
        self.genre = genre
        self.year = year
        self.director = director
        self.overview = overview
        self.posterPath = posterPath
    }
}

extension MovieModel: @unchecked Sendable {}
