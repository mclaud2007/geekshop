//
//  AuthRequestFactory.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 19.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

protocol AuthRequestFactory {
    func login(userName: String, password: String, completionHandler: @escaping (Alamofire.DataResponse<LoginResult>) -> Void)
    func logout(completionHandler: @escaping (DataResponse<LogoutResult>) -> Void)
}
