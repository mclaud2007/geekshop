//
//  UsersRequestStruct.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

extension Users {
    struct Login: RequestRouter {
        var path: String = "login"
        let baseUrl: URL
        let method: HTTPMethod = .get
        
        let login: String
        let password: String
        
        var parameters: Parameters? {
            return [
                "username": login,
                "password": password
            ]
        }
    }
    
    struct Logout: RequestRouter {
        var path: String = "logout"
        let baseUrl: URL
        let method: HTTPMethod = .get
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
    
    struct GetUser: RequestRouter {
        var path: String = "get"
        let baseUrl: URL
        let method: HTTPMethod = .get
        
        let userId: Int
        var parameters: Parameters? {
            return [
                "userId": userId
            ]
        }
    }
    
    struct UserData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "change"
        
        let userId: Int
        let login: String
        let password: String
        let email: String
        let firstName: String
        let lastName: String?
        
        var parameters: Parameters? {
            return [
                "username": login,
                "password": password,
                "first_name": firstName,
                "last_name": lastName ?? "",
                "email": email,
                "userId": userId
            ]
        }
    }
    
    struct RegisterData: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = "register"
        
        let login: String
        let password: String
        let email: String
        let firstName: String
        let lastName: String?
        
        var parameters: Parameters? {
            return [
                "username": login,
                "password": password,
                "first_name": firstName,
                "last_name": lastName ?? "",
                "email": email
            ]
        }
    }
}
