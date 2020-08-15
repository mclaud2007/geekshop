//
//  CatalogResult.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

typealias CatalogResult = [Product]

struct Product: Codable {
    let idProduct, productPrice: Int
    let productName, productImage: String
    
    enum CodingKeys: String, CodingKey {
        case idProduct = "id_product"
        case productName = "product_name"
        case productImage = "product_image"
        case productPrice = "price"
    }
}
