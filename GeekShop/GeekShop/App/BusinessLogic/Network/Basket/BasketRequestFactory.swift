//
//  BasketRequestFactory.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 04.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

protocol BasketRequestFactory: AbstractRequestFactory {
    // Получаем карзину пользователя по id сессии
    func getBasketBy(sessionId: Int, completion: @escaping (Alamofire.DataResponse<GetBasketResult>) -> Void)
    
    // Добавление товара в корзину
    func addProductToBasketBy(productId: Int, sessionId: Int,
                              quantity: Int, completion: @escaping (Alamofire.DataResponse<AddToBasketResult>) -> Void)
    
    // Удаление товара из корзины
    func removeProductFromBasketBy(productId: Int, sessionId: Int, completion: @escaping (Alamofire.DataResponse<RemoveFromBasketResult>) -> Void)
    
    // Оплата заказа
    func payOrderBy(sessionId: Int, paySumm: Int, completion: @escaping (Alamofire.DataResponse<PayOrderResult>) -> Void)
}
