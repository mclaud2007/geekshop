//
//  Baskets.swift
//  
//
//  Created by Григорий Мартюшин on 12.08.2020.
//

import Fluent
import Vapor

final class Baskets: Model, Content {
    static let schema = "baskets"
        
    @ID(key: .id)
    var id: UUID?

    @Field(key: "id_product")
    var idProduct: Int
    
    @Field(key: "user_id")
    var userId: Int
    
    @Field(key: "product_name")
    var productName: String
        
    @Field(key: "price")
    var price: Int
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() { }
    
    init(idProduct: Int, userId: Int, productName: String, price: Int, quantity: Int) {
        self.idProduct = idProduct
        self.userId = userId
        self.productName = productName
        self.price = price
        self.quantity = quantity
        self.id = nil
    }
}

extension Baskets: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Создаем базу с пользователями
        let result = database.schema("baskets")
            .id()
            .field("id_product", .int, .required)
            .field("user_id", .int, .required)
            .field("product_name", .string, .required)
            .field("price", .int, .required)
            .field("quantity", .int, .required)
            .create()
        
        // Добавляем одну запись
        let _ = Baskets(idProduct: 1, userId: 1, productName: "Razer Basilisk Ultimate", price: 14990, quantity: 2).save(on: database)
        
        let _ = Baskets(idProduct: 2, userId: 1, productName: "MacBook Pro 16 дюймов", price: 199990, quantity: 1).save(on: database)
        
        return result
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("baskets").delete()
    }
}
