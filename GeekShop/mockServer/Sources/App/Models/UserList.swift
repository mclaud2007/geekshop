//
//  File.swift
//  
//
//  Created by Григорий Мартюшин on 28.07.2020.
//

import Fluent
import Vapor

final class UserList: Model {
    static let schema = "userList"
        
    @ID(key: .id)
    var id: UUID?
    
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
    
    init() {
        self.username = ""
        self.password = ""
        self.firstName = ""
        self.lastName = nil
        self.email = ""
    }
    
    init(id: UUID? = nil, username: String, password: String, firstName: String, lastName: String, email: String) {
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
    }
}

extension UserList: Content {}

