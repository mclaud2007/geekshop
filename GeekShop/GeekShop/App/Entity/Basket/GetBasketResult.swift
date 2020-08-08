//
//  GetBasketResult.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 04.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

struct GetBasketResult: Codable {
    let amount: Int
    let countGoods: Int
    let contents: [BasketContents]
}

struct BasketContents: Codable {
    let idProduct, productPrice, quantity: Int
    let productName: String
    
    enum CodingKeys: String, CodingKey {
        case idProduct = "id_product"
        case productName = "product_name"
        case productPrice = "price"
        case quantity = "quantity"
    }
}
