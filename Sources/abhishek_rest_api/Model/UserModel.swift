//
//  File.swift
//  abhishek_rest_api
//
//  Created by Abhishek Bagela on 07/03/26.
//

import Foundation
import Vapor
import FluentKit

final class UserModel: Model, Content {
    // Name of the table or collection.
    static let schema: String = "users"
    
    // Unique identifier for this User.
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "age")
    var age: Int
    
    @Field(key: "address")
    var address: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, age: Int, address: String) {
        self.id = id
        self.name = name
        self.age = age
        self.address = address
    }
}

extension UserModel: @unchecked Sendable {}
