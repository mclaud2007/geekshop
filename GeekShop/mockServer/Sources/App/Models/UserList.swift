//
//  UserList.swift
//  
//
//  Created by Григорий Мартюшин on 28.07.2020.
//

import Fluent
import Vapor

final class UserList: Model, Content {
    static let schema = "userList"
        
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "userId")
    var userId: Int?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "first_name")
    var firstName: String
    
    @OptionalField(key: "last_name")
    var lastName: String?
    
    @Field(key: "email")
    var email: String
    
    init() { }
    
    init(id: Int? = nil, username: String, password: String, firstName: String, lastName: String, email: String) {
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userId = id
    }
}

//extension UserList: Content {}

extension UserList: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Создаем базу с пользователями
        let result = database.schema("userList")
            .id()
            .field("userId", .int, .required)
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("first_name", .string, .required)
            .field("last_name", .string)
            .field("email", .string, .required)
            .create()
        
        // Добавляем одну запись
        let _ = UserList(id: 1, username: "test", password: "test",
                         firstName: "John", lastName: "Doe",
                         email: "test@mail.ru")
            .save(on: database)
        
        return result
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("userList").delete()
    }
}
