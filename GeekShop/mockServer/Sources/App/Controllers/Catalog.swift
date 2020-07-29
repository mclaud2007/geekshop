//
//  File.swift
//  
//
//  Created by Григорий Мартюшин on 29.07.2020.
//

import Foundation
import Vapor

class Catalog {
    let resulter = ShowResults()
    let catalogDB: [Dictionary<String,Any>] = [["id_product": 123,
                                              "product_name": "Ноутбук",
                                              "price": 45600,
                                              "product_description": "Мощный игровой ноутбук"],
                                             ["id_product": 456,
                                              "product_name": "Мышка",
                                              "price": 1000,
                                              "product_description": "Мощная игровая мышка"]]
    
    struct CatalogGetParam: Content {
        var id: Int?
    }
    
    func doAction(action: String, queryString: URLQueryContainer?) -> String {
        switch action {
        case "list":
            return list(queryString)
        case "product":
            return product(queryString)
        default:
            return resulter.returnError(message: "Unknown method")
        }
    }
    
    func list(_ queryString: URLQueryContainer? = nil) -> String {
        var resultList: [Dictionary<String,Any>] = []
        var good: Dictionary<String,Any>
        
        for var product in catalogDB {
            // Внезапно в списке товаров не нужно описание :)
            product.removeValue(forKey: "product_description")
            good = product
            
            // Формируем массив с результатами
            resultList.append(good)
        }
        
        return resulter.returnArrayResult(resultList)
    }
    
    func product(_ queryString: URLQueryContainer? = nil) -> String {
        guard let query = try? queryString?.get(CatalogGetParam.self),
            let productId = query.id else {
            return resulter.returnError(message: "Good not found")
        }
        
        // Ищем запрошенный товар
        let product = catalogDB.filter { product in
            if let pID = product["id_product"] as? Int,
                pID == productId {
                return true
            }
            
            return false
        }
        
        if let firstProduct = product.first,
            let name = firstProduct["product_name"],
            let price = firstProduct["price"],
            let description = firstProduct["product_description"]
        {
            let result: Dictionary<String,Any> = ["product_name": name, "product_price": price, "product_description": description]
            
            return resulter.returnResult(result)
        }
        
        return resulter.returnError(message: "Good not found")
    }
}

