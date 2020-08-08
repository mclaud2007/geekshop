//
//  ReviewsRequestStruct.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 01.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

extension Reviews {
    struct ReviewData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "list"
        
        let productId: Int
        var parameters: Parameters? {
            return [
                "productId": productId
            ]
        }
    }
    
    struct ReviewDataAdd: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "add"
        
        let productId: Int
        let userName, userEmail, title, description: String
        
        var parameters: Parameters? {
            return [
                "productId": productId,
                "user_name": userName,
                "user_email": userEmail,
                "title": title,
                "description": description
            ]
        }
    }
    
    struct ReviewDataApprove: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "approve"
        
        let reviewId: Int
        
        var parameters: Parameters? {
            return [
                "reviewId": reviewId
            ]
        }
    }
    
    struct ReviewDataRemove: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "remove"
        
        let reviewId: Int
        
        var parameters: Parameters? {
            return [
                "reviewId": reviewId
            ]
        }
        
    }
}
