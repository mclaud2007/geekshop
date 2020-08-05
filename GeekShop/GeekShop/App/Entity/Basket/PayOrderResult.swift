//
//  PayOrderResult.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 04.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

struct PayOrderResult: Codable {
    let result: Int
    let message: String?
}
