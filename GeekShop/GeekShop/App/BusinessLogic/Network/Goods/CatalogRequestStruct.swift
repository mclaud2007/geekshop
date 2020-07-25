//
//  CatalogRequestStruct.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

extension Catalog {
    struct CatalogData: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "catalogData.json"
        var parameters: Parameters? = nil
    }
    
    struct GoodById: RequestRouter {
        var baseUrl: URL
        var method: HTTPMethod = .get
        var path: String = "getGoodById.json"
        
        let productId: Int
        var parameters: Parameters? = nil
        
    
    }
}
