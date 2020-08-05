//
//  BasketRequestStruct.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 04.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

extension Basket {
    struct GetBasketData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "get"
        
        let sessionId: Int
        var parameters: Parameters? {
            return [
                "sessionId": sessionId
            ]
        }
    }
    
    struct AddToBasketData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "add"
        
        let sessionId: Int
        let productId: Int
        let quantity: Int
        
        var parameters: Parameters? {
            return [
                "sessionId": sessionId,
                "productId": productId,
                "quantity": quantity
            ]
        }
    }
    
    struct RemoveFromBasketData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "remove"
        
        let sessionId: Int
        let productId: Int
        
        var parameters: Parameters? {
            return [
                "sessionId": sessionId,
                "productId": productId
            ]
        }
    }
    
    struct PayOrderData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "pay"
        
        let sessionId: Int
        let paySumm: Int
        
        var parameters: Parameters? {
            return [
                "sessionId": sessionId,
                "paySumm": paySumm
            ]
        }
        
    }
}
