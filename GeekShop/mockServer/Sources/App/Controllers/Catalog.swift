//
//  Catalog.swift
//  
//
//  Created by Григорий Мартюшин on 29.07.2020.
//

import Fluent
import FluentSQLiteDriver
import Vapor

class Catalog {
    // MARK: Properties
    let resulter: View!
    let req: Request!
    
    struct GetProduct: Content {
        var id: Int?
    }
    
    // MARK: Methods
    init(_ req: Request) {
        self.resulter = View(req: req)
        self.req = req
    }
    
    // MARK: Catalog router
    func doAction(action: String) -> EventLoopFuture<String> {
        switch action {
        case "list":
            return list()
        case "product":
            return product()
        default:
            return resulter.error(message: "Unknown method")
        }
    }
    
    // MARK: Получение списка товаров
    func list() -> EventLoopFuture<String> {
        return CatalogList.query(on: req.db)
            .all().map { catalog -> [[String: Any]] in
                return catalog.map { item -> [String: Any] in
                    if let idProduct = item.$idProduct.value,
                        let productName = item.$productName.value,
                        let price = item.$price.value {
                        
                        return ["id_product": idProduct,
                                "product_name": productName,
                                "product_image": ((item.$productImage.value ?? "") ?? ""),
                                "price": price]
                    } else {
                        return [:]
                    }
                }
        }.flatMap { result -> EventLoopFuture<String> in
            return self.resulter.items(message: result)
        }
    }
    
    // MARK: Поиск товара в базе
    func productBy(_ productId: Int) -> EventLoopFuture<CatalogList?> {
        // Ищем запрошенный товар
        return CatalogList.query(on: req.db)
            .filter(\.$idProduct, .equal, productId)
            .limit(1)
            .first()
    }
    
    // MARK: Получение товара по его ID
    func product() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetProduct.self),
            let productId = query.id else {
                return resulter.error(message: "Good not found")
        }
        
        return productBy(productId).map { catalog -> [String: Any]? in
            if let catalog = catalog,
                let productName = catalog.$productName.value,
                let productPrice = catalog.$price.value,
                let productDescription = catalog.$productDescription.value {
                
                return ["product_name": productName,
                        "product_price": productPrice,
                        "product_description":productDescription,
                        "product_image": ((catalog.$productImage.value ?? "") ?? "")
                ]
            } else {
                return nil
            }
        }.flatMap { result -> EventLoopFuture<String> in
            if let result = result {
                return self.resulter.item(message: result)
            } else {
                return self.resulter.error(message: "Product not found")
            }
        }        
    }
}

