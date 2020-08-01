//
//  GoodResult.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

struct ProductResult: Codable {
    let result, productPrice: Int
    let productName, productDescription: String
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productPrice = "product_price"
        case productDescription = "product_description"
        case result = "result"
    }
}
