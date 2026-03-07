//
//  File.swift
//  abhishek_rest_api
//
//  Created by Abhishek Bagela on 07/03/26.
//

import Foundation
import Vapor

struct User: Content {
    var id: String
    var name: String
    var age: String
    var address: String
}
