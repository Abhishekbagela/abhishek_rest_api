//
//  File.swift
//  abhishek_rest_api
//
//  Created by Abhishek Bagela on 08/03/26.
//

import Foundation
import FluentKit

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("age", .int)
            .field("address", .string)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
