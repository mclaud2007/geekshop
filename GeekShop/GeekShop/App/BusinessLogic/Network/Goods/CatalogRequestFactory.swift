//
//  CatalogRequestFactory.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

protocol CatalogRequestFactory: AbstractRequestFactory {
    func getProductsList(completion: @escaping (Alamofire.DataResponse<CatalogResult>) -> Void)
    func getProductBy(productId: Int, competion: @escaping (Alamofire.DataResponse<ProductResult>) -> Void)
}
