//
//  Register.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 19.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

class Register: AbstractRequestFactory {
    let errorParser: AbstractErrorParser
    let sessionManager: SessionManager
    let queue: DispatchQueue?
    let baseUrl = URL(string: "https://raw.githubusercontent.com/mclaud2007/online-store-api/master/responses/")!
    
    init(
            errorParser: AbstractErrorParser,
            sessionManager: SessionManager,
            queue: DispatchQueue? = DispatchQueue.global(qos: .utility))
    {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Register {
    struct UserData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "registerUser.json"
        
        let login: String
        let password: String
        let email: String
        let name: String
        let lastName: String
        
        var parameters: Parameters? {
            return [
                "username": login,
                "password": password,
                "first_name": name,
                "last_name": lastName,
                "email": email
            ]
        }
    }
}

extension Register: RegisterRequestFactory {
    func doRegister(login: String,
                  password: String,
                  firstName: String,
                  lastName: String? = "",
                  email: String,
                  completionHandler: @escaping (DataResponse<RegisterResult>) -> Void)
    {
        let requsetModel = UserData(baseUrl: baseUrl, login: login, password: password, email: email, name: firstName, lastName: lastName ?? "")
        self.request(request: requsetModel, completionHandler: completionHandler)
    }
}
