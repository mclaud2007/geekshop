//
//  RequestFactory.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 19.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire
import Swinject

class RequestFactory {
    lazy var commonSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
        
    func makeUsersFactory() -> Users {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Users.self) { r in
            Users(errorParser: r.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSessionManager)
        }
        
        return container.resolve(Users.self)!
    }
    
    func makeCatalogFactory() -> Catalog {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Catalog.self) { r in
            Catalog(errorParser: r.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSessionManager)
        }
        
        return container.resolve(Catalog.self)!
    }
}
