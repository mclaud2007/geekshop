//
//  GetUserDataResult.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 09.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

struct GetUserDataResult: Codable {
    var result, idUser: Int
    var userLogin, userPassword, firstName, lastName, userEmail: String
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case idUser = "id_user"
        case userLogin = "user_login"
        case userPassword = "user_password"
        case firstName = "user_name"
        case lastName = "user_lastname"
        case userEmail = "user_email"
    }
}
