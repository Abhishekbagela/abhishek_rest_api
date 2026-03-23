//
//  File.swift
//  abhishek_rest_api
//
//  Created by Abhishek Bagela on 08/03/26.
//

import Foundation
import Vapor
import Fluent
import VaporToOpenAPI

struct UserController: UserControllerProtocol {
    
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: fetchAll(_:))
            .openAPI(tags: "Users", summary: "Fetch all users")
        users.post(use: add(_:))
            .openAPI(tags: "Users", summary: "Add a new user")
        users.group(":id") { user in
            user.get(use: fetch(_:))
                .openAPI(tags: "Users", summary: "Fetch a user by ID")
            user.put(use: update(_:))
                .openAPI(tags: "Users", summary: "Update a user")
            user.delete(use: remove(_:))
                .openAPI(tags: "Users", summary: "Delete a user")
        }
    }
    
    @Sendable
    func fetch(_ request: Request) async throws -> UserModel {
        guard let user = try await UserModel.find(request.parameters.get("id"), on: request.db)
        else {
            throw Abort(.notFound)
        }
        return user
    }
    
    @Sendable
    func fetchAll(_ request: Request) async throws -> Page<UserModel> {
        try await UserModel.query(on: request.db).paginate(for: request)
    }
    
    @Sendable
    func add(_ request: Request) async throws -> UserModel {
        let user = try request.content.decode(UserModel.self)
        try await user.save(on: request.db)
        return user
    }
    
    @Sendable
    func update(_ request: Request) async throws -> UserModel {
        guard let user = try await UserModel.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.notFound)
        }
        let updatedUser = try request.content.decode(UserModel.self)
        user.name = updatedUser.name
        user.age = updatedUser.age
        user.address = updatedUser.address
        try await user.save(on: request.db)
        return user
    }
    
    @Sendable
    func remove(_ request: Request) async throws -> HTTPStatus {
        guard let user = try await UserModel.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: request.db)
        return .noContent
    }
}


protocol UserControllerProtocol: RouteCollection {
    func boot(routes: any RoutesBuilder) throws
    func fetch(_ request: Request) async throws -> UserModel
    func fetchAll(_ request: Request) async throws -> Page<UserModel>
    func add(_ request: Request) async throws -> UserModel
    func update(_ request: Request) async throws -> UserModel
    func remove(_ request: Request) async throws -> HTTPStatus
}
