//
//  Catalog.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

class Catalog: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    let baseUrl = URL(string: "http://127.0.0.1:8080/catalog/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: SessionManager,
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Catalog: CatalogRequestFactory {
    func getProductsList(completion: @escaping (DataResponse<CatalogResult>) -> Void) {
        let requestModel = CatalogData(baseUrl: baseUrl)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func getProductBy(productId: Int, competion: @escaping (DataResponse<ProductResult>) -> Void) {
        let requestModel = GoodById(baseUrl: baseUrl, productId: productId)
        self.request(request: requestModel, completionHandler: competion)
    }
}
