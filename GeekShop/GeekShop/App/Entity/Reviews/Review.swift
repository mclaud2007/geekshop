//
//  Review.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 01.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

struct Review: Codable {
    let reviewId: Int?
    let productId: Int?
    let userName, userEmail, title, description: String
    
    enum CodingKeys: String, CodingKey {
        case reviewId = "id"
        case productId = "id_product"
        case userName = "user_name"
        case userEmail = "user_email"
        case title = "title"
        case description = "description"
    }
}
