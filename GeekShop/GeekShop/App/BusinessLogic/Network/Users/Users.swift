//
//  User.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

class Users: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    let baseUrl = URL(string: "http://127.0.0.1:8080/users/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: SessionManager,
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility))
    {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Users: UsersRequestFactory {
    func loginWith(userLogin: String, userPassword: String, completion: @escaping (DataResponse<LoginResult>) -> Void)
    {
        let requestModel = Login(baseUrl: baseUrl, login: userLogin, password: userPassword)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func logoutCurrentUser(completion: @escaping (DataResponse<LogoutResult>) -> Void) {
        let requestModel = Logout(baseUrl: baseUrl, userId: 1)
        self.request(request: requestModel, completionHandler: completion)
    }

    func changeUserDataBy(id: Int,
                          firstName: String, lastName: String?,
                          userLogin: String, userPassword: String,
                          userEmail: String,
                          completion: @escaping (DataResponse<ChangeUserDataResult>) -> Void)
    {
        let requestModel = UserData(baseUrl: baseUrl, userId: id, login: userLogin, password: userPassword, email: userEmail, firstName: firstName, lastName: lastName)
        self.request(request: requestModel, completionHandler: completion)
    }

    func registerUserWith(firstName: String, lastName: String?,
                          userLogin: String, userPassword: String,
                          userEmail: String,
                          completion: @escaping (DataResponse<RegisterResult>) -> Void)
    {
        let requestModel = RegisterData(baseUrl: baseUrl, login: userLogin, password: userPassword, email: userEmail, firstName: firstName, lastName: lastName)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    
}
