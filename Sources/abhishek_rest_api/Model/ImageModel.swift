import Foundation
import Vapor
import FluentKit

final class ImageModel: Model, Content {
    static let schema = "images"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "url")
    var url: String
    
    @Field(key: "type")
    var type: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, url: String, type: String) {
        self.id = id
        self.name = name
        self.url = url
        self.type = type
    }
}

extension ImageModel: @unchecked Sendable {}
