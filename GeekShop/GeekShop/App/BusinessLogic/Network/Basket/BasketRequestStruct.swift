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
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
    
    struct AddToBasketData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "add"
        
        let userId: Int
        let productId: Int
        let quantity: Int
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "productId": productId,
                "quantity": quantity
            ]
        }
    }
    
    struct RemoveFromBasketData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "remove"
        
        let userId: Int
        let productId: Int
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "productId": productId
            ]
        }
    }
    
    struct PayOrderData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "pay"
        
        let userId: Int
        let paySumm: Int
        
        var parameters: Parameters? {
            return [
                "userId": userId,
                "paySumm": paySumm
            ]
        }
    }
    
    struct ClearBasketData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "clear"
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
}
