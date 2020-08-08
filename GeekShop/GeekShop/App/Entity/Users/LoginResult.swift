//
//  LoginResult.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 19.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

// MARK: - LoginResult
struct LoginResult: Codable {
    let result: Int
    let user: UserResult
    let authToken: String
}
