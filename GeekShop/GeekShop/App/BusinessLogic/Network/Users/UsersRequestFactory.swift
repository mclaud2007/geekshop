//
//  UserRequestFactory.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

protocol UsersRequestFactory {
    func loginWith(userLogin: String, userPassword: String, completion: @escaping (Alamofire.DataResponse<LoginResult>) -> Void)
    func logoutCurrentUser(completion: @escaping (Alamofire.DataResponse<LogoutResult>) -> Void)
    
    func changeUserDataBy(id: Int,
                          firstName: String, lastName: String?,
                          userLogin: String, userPassword: String,
                          userEmail: String,
                          completion: @escaping (Alamofire.DataResponse<ChangeUserDataResult>) -> Void)
    
    func registerUserWith(firstName: String, lastName: String?,
                          userLogin: String, userPassword: String,
                          userEmail: String,
                          completion: @escaping (Alamofire.DataResponse<RegisterResult>) -> Void)
}
