//
//  ReviewList.swift
//  
//
//  Created by Григорий Мартюшин on 11.08.2020.
//

import Fluent
import Vapor

final class ReviewList: Model, Content {
    static let schema = "reviewList"
        
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "review_id")
    var reviewId: Int

    @Field(key: "id_product")
    var idProduct: Int
    
    @Field(key: "user_name")
    var userName: String
    
    @Field(key: "user_email")
    var userEmail: String
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "show")
    var show: Bool
    
    @Field(key: "description")
    var reviewDescription: String
    
    init() { }
    
    init(id: Int? = nil, idProduct: Int, userName: String, userEmail: String, title: String, show: Bool, reviewDescription: String) {
        self.reviewId = id ?? -1
        self.idProduct = idProduct
        self.userName = userName
        self.userEmail = userEmail
        self.title = title
        self.show = show
        self.reviewDescription = reviewDescription
    }
}

extension ReviewList: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Создаем базу с пользователями
        let result = database.schema("reviewList")
            .id()
            .field("review_id", .int, .required)
            .field("id_product", .int, .required)
            .field("user_name", .string, .required)
            .field("user_email", .string, .required)
            .field("title", .string, .required)
            .field("show", .bool, .required)
            .field("description", .string, .required)
            .create()
        
        // Добавляем одну запись
        let rev1 = ReviewList(id: 1, idProduct: 1, userName: "Test", userEmail: "test@mail.ru",
                              title: "Отзыв о мышке", show: true, reviewDescription: "Нормальная мышка")
        
        let rev2 = ReviewList(id: 2, idProduct: 2, userName: "Test 12", userEmail: "test@mail.ru",
                              title: "Отзыв о ноутбуке", show: true, reviewDescription: "Нормальный ноутбук")
        
        let _ = rev1.save(on: database)
        let _ = rev2.save(on: database)
        
        return result
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("reviewList").delete()
    }
}
