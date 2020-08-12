//
//  User.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 19.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

// MARK: - User
struct UserResult: Codable {
    let idUser: Int
    let userLogin, userName, userLastname, userEmail: String

    enum CodingKeys: String, CodingKey {
        case idUser = "id_user"
        case userLogin = "user_login"
        case userName = "user_name"
        case userLastname = "user_lastname"
        case userEmail = "user_email"
    }
}
