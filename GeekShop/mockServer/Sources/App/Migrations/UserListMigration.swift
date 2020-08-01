//
//  File.swift
//  
//
//  Created by Григорий Мартюшин on 28.07.2020.
//

import Fluent

extension UserList: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("userList")
            .id()
            .field("username", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("userList").delete()
    }
}
