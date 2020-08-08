//
//  File.swift
//  
//
//  Created by Григорий Мартюшин on 04.08.2020.
//

import Foundation
import Vapor

typealias BasketStruct = Dictionary<String,Any>
typealias BasketItem = Dictionary<String,Any>
typealias PayResult = Dictionary<String,Any>

class Basket {
    let resulter = ShowResults()
    var basket: [BasketItem] = [
                                    ["id_product": 456,
                                     "price": 1000,
                                     "product_name": "Мышка",
                                     "quantity": 2
                                    ]
    ]
    
    struct BasketGetParam: Content {
        var sessionId: Int?
    }
    
    struct BasketAddParam: Content {
        var sessionId: Int?
        var productId: Int?
        var quantity: Int?
    }
    
    struct BasketRemoveParam: Content {
        var sessionId: Int?
        var productId: Int?
    }
    
    struct BasketPayParam: Content {
        var sessionId: Int?
        var paySumm: Int?
    }
    
    func doAction(action: String, queryString: URLQueryContainer?) -> String {
        switch action {
        case "get":
            return getBasket(queryString)
        case "add":
            return addToBasket(queryString)
        case "remove":
            return removeFromBasket(queryString)
        case "pay":
            return payOrder(queryString)
        default:
            return resulter.returnError(message: "Unknown method")
        }
    }
    
    func getBasket(_ queryString: URLQueryContainer? = nil) -> String {
        guard let query = try? queryString?.get(BasketGetParam.self),
              let _ = query.sessionId else {
                return resulter.returnError(message: "Session not found")
        }
        
        if !basket.isEmpty {
            // Считаем общее количество товара
            var amount: Int = 0
            
            basket.forEach { (product: Product) in
                if let count = product["quantity"] as? Int {
                    amount += count
                }
            }
            
            let result: BasketStruct = ["amount": amount,
                                        "countGoods": basket.count,
                                        "contents": basket
            ]
            
            return resulter.returnResult(result)
        } else {
            return resulter.returnError(message: "Basket empty")
        }
    }
    
    func addToBasket(_ queryString: URLQueryContainer? = nil) -> String {
        guard let query = try? queryString?.get(BasketAddParam.self),
            let _ = query.sessionId,
            let productId = query.productId,
            let quantity = query.quantity else {
                return resulter.returnError(message: "Wrong parameter count")
        }
        
        if let product = Catalog().productBy(productId),
            let firstProduct = product.first,
            let productName = firstProduct["product_name"],
            let productPrice = firstProduct["price"] {
            
            let product: BasketItem = ["id_product": productId,
                                       "price": productPrice,
                                       "product_name": productName,
                                       "quantity":quantity
            ]
            
            basket.append(product)
            
            return resulter.returnResult()
        } else {
            return resulter.returnError(message: "Can't find product with id: \(productId)")
        }
    }
    
    func removeFromBasket(_ queryString: URLQueryContainer? = nil) -> String {
        guard let query = try? queryString?.get(BasketRemoveParam.self),
            let _ = query.sessionId,
            let productId = query.productId else {
                return resulter.returnError(message: "Wrong parameter count")
        }
        
        if !basket.isEmpty {
            for i in 0..<basket.count {
                if let pID = basket[i]["id_product"] as? Int,
                    pID == productId {
                    basket.remove(at: i)
                    return resulter.returnResult()
                }
            }
            
            return resulter.returnError(message: "Product with id: \(productId) not found in basket")
        } else {
            return resulter.returnError(message: "Basket is empty")
        }
    }
    
    func payOrder(_ queryString: URLQueryContainer? = nil) -> String {
        guard let query = try? queryString?.get(BasketPayParam.self),
            let _ = query.sessionId,
            let paySumm = query.paySumm else {
                return resulter.returnError(message: "Wrong parameter count")
        }
        
        if !basket.isEmpty {
            // Считаем общую сумму товаров
            var totalPrice: Int = 0
            
            basket.forEach { (product: Product) in
                if let count = product["quantity"] as? Int,
                    let price = product["price"] as? Int {
                    totalPrice += (price * count)
                }
            }
            
            if totalPrice > 0 && paySumm == totalPrice {
                let result: PayResult = ["result": 1, "message": "Корзина полностью оплачена. Сумма \(totalPrice)"]
                
                return resulter.returnResult(result)
            } else {
                guard totalPrice > 0 else {
                    return resulter.returnError(message: "Ошибка подсчета суммы товаров в корзине")
                }
                
                guard paySumm != totalPrice else {
                    return resulter.returnError(message: "Не хватает денег")
                }
                
                return resulter.returnError(message: "Что-то пошло не так.")
            }
        } else {
            return resulter.returnError(message: "Basket is empty")
        }
        
    }
}
