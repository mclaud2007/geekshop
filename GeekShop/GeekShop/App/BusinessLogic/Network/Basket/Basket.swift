//
//  Basket.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 04.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

class Basket: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    var baseUrl = URL(string: "http://127.0.0.1:8080/basket/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: SessionManager,
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Basket: BasketRequestFactory {
    func getBasketBy(sessionId: Int, completion: @escaping (DataResponse<GetBasketResult>) -> Void) {
        let requestModel = GetBasketData(baseUrl: baseUrl, sessionId: sessionId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func addProductToBasketBy(productId: Int, sessionId: Int, quantity: Int, completion: @escaping (DataResponse<AddToBasketResult>) -> Void) {
        let requestModel = AddToBasketData(baseUrl: baseUrl, sessionId: sessionId,
                                           productId: productId, quantity: quantity)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func removeProductFromBasketBy(productId: Int, sessionId: Int, completion: @escaping (DataResponse<RemoveFromBasketResult>) -> Void) {
        let requestModel = RemoveFromBasketData(baseUrl: baseUrl, sessionId: sessionId, productId: productId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func payOrderBy(sessionId: Int, paySumm: Int, completion: @escaping (DataResponse<PayOrderResult>) -> Void) {
        let requestModel = PayOrderData(baseUrl: baseUrl, sessionId: sessionId, paySumm: paySumm)
        self.request(request: requestModel, completionHandler: completion)
    }
    
}
