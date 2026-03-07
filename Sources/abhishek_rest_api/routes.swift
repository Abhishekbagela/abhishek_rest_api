import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    ////MARK:  Users
    
    app.group("users") { users in
        print("users")
        
        //get user by id
        users.get(":id") { request async throws -> User in
            if request.method != .GET {
                throw Abort(.methodNotAllowed)
            }
            
            guard let id = request.parameters.get("id") else {
                throw Abort(.custom(code: .zero, reasonPhrase: "id param required"))
            }

            print("users:\(id)")
            
            if let user = DummyUserJson.users.filter({ $0.id == id }).first {
                print("users:\(id) => \(user.id)")
                return user
            } else {
                throw Abort(.noContent)
            }
        }
        
        //get all user
//        users.get("*") { request in
//            return DummyUserJson.users
//        }
        /*
        // create a user
        users.post(<#T##path: PathComponent...##PathComponent#>) { request in
            <#code#>
        }
        
        users.put(<#T##path: PathComponent...##PathComponent#>) { request in
            <#code#>
        }
        
        users.patch(<#T##path: PathComponent...##PathComponent#>) { request in
            <#code#>
        }
        
        users.delete(":id") { request in
            <#code#>
        }
         */
    }
    
}


struct DummyUserJson {
    static let users: [User] = [
        User(id: "1", name: "Abhishek", age: "29", address: "Indore"),
        User(id: "2", name: "Anju", age: "29", address: "Dewas"),
        User(id: "3", name: "Ravi", age: "26", address: "Bhopal"),
        User(id: "4", name: "Annu", age: "30", address: "Sihor"),
        User(id: "5", name: "Vijay", age: "32", address: "Ujjain")
    ]
}
