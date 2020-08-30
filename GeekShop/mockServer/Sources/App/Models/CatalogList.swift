//
//  CatalogList.swift
//  
//
//  Created by Григорий Мартюшин on 11.08.2020.
//

import Fluent
import Vapor

final class CatalogList: Model, Content {
    static let schema = "catalogList"
        
    @ID(key: .id)
    var id: UUID?

    @Field(key: "id_product")
    var idProduct: Int
    
    @Field(key: "product_name")
    var productName: String
    
    @Field(key: "product_image")
    var productImage: String?
    
    @Field(key: "price")
    var price: Int
    
    @Field(key: "product_description")
    var productDescription: String
    
    init() { }
    
    init(id: Int? = nil, productName: String, price: Int, productDescription: String, productImage: String?) {
        self.idProduct = id ?? -1
        self.productName = productName
        self.productDescription = productDescription
        self.price = price
        self.productImage = productImage
    }
}

extension CatalogList: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Создаем базу с пользователями
        let result = database.schema("catalogList")
            .id()
            .field("id_product", .int, .required)
            .field("product_name", .string, .required)
            .field("product_image", .string)
            .field("price", .int, .required)
            .field("product_description", .string, .required)
            .create()
        
        // Добавляем одну запись
        let cat1 = CatalogList(id: 1, productName: "Razer Basilisk Ultimate",
                               price: 14990,
                               productDescription: "С Razer Basilisk Ultimate победа будет полностью в ваших руках. Эту высокопроизводительную беспроводную игровую мышь можно настроить так, чтобы она выглядела, играла и чувствовалась именно так, как хочется именно вам. У ваших соперников нет никаких шансов.",
                               productImage: "https://static.razer.ru/213316/basilisk-ultimate-usp3-mobile.jpg")
            
        let cat2 = CatalogList(id: 2, productName: "MacBook Pro 16 дюймов",
                               price: 199990,
                               productDescription: "Новый MacBook Pro — наш самый мощный ноутбук, созданный для тех, кто меняет мир и раздвигает границы. Впечатляющий дисплей Retina 16 дюймов, невероятно быстрый процессор, графическая карта нового поколения, самый ёмкий аккумулятор в истории MacBook Pro, новая клавиатура Magic Keyboard и вместительный накопитель — это лучший профессиональный ноутбук для самых серьёзных профессионалов.",
                               productImage: "https://www.ixbt.com/img/r30/00/02/25/30/Apple16inchMacBookPro111319large.jpg")
            
        let _ = cat1.save(on: database)
        let _ = cat2.save(on: database)
        
        return result
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("catalogList").delete()
    }
}
