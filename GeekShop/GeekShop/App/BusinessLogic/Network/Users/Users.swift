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
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Users: UsersRequestFactory {    
    func loginWith(userLogin: String, userPassword: String, completion: @escaping (DataResponse<LoginResult>) -> Void) {
        let requestModel = Login(baseUrl: baseUrl, login: userLogin, password: userPassword)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func logoutCurrentUser(completion: @escaping (DataResponse<LogoutResult>) -> Void) {
        let requestModel = Logout(baseUrl: baseUrl, userId: 1)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func getUserBy(userId: Int, completion: @escaping (DataResponse<GetUserDataResult>) -> Void) {
        let requestModel = GetUser(baseUrl: baseUrl, userId: userId)
        self.request(request: requestModel, completionHandler: completion)
    }

    func changeUserFrom(user data: User, completion: @escaping (DataResponse<ChangeUserDataResult>) -> Void) {
        guard let userId = data.userId else { return }
        
        let requestModel = UserData(baseUrl: baseUrl,
                                    userId: userId, login: data.login, password: data.password,
                                    email: data.email, firstName: data.firstName, lastName: data.lastName)
        
        self.request(request: requestModel, completionHandler: completion)
    }

    func registerUserWith(user data: User, completion: @escaping (DataResponse<RegisterResult>) -> Void) {
        let requestModel = RegisterData(baseUrl: baseUrl,
                                        login: data.login, password: data.password,
                                        email: data.email, firstName: data.firstName,
                                        lastName: data.lastName)
        
        self.request(request: requestModel, completionHandler: completion)
    }
    
}
