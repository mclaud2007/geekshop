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
        
    func makeAuthRequestFactory() -> Auth {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Auth.self) { r in
            Auth(errorParser: r.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSessionManager)
        }
        
        return container.resolve(Auth.self)!
    }
    
    func makeRegisterRequestFactory() -> RegisterRequestFactory {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(Register.self) { r in
            Register(errorParser: r.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSessionManager)
        }
        
        return container.resolve(Register.self)!
    }
    
    func makeChangeUserDataRequestFactory() -> ChangeUserDataRequestFactory {
        let container = Container()
        
        container.register(AbstractErrorParser.self) { _ in ErrorParser() }
        container.register(ChangeUserData.self) { r in
            ChangeUserData(errorParser: r.resolve(AbstractErrorParser.self)!, sessionManager: self.commonSessionManager)
        }
        
        return container.resolve(ChangeUserData.self)!
    }
}
