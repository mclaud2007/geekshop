//
//  RewievsRequestProtocol.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 01.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

protocol ReviewsRequestFactory: AbstractRequestFactory {
    // Получение списка отзывов на товар по id (товара)
    func getReviewsForProductBy(productId: Int, completion: @escaping (Alamofire.DataResponse<GetReviewsResult>) -> Void)
    
    // Добавление отзыва к товару
    func addReviewForProductBy(productId: Int, review: Review, completion: @escaping (Alamofire.DataResponse<AddReviewResult>) -> Void)
    
    // Одобрение (к публикации) отзыва
    func setReviewApporoveBy(reviewId: Int, completion: @escaping (Alamofire.DataResponse<ApproveReviewResult>) -> Void)
    
    // Удаление отзыва по id (отзыва)
    func removeReviewBy(reviewId: Int, completion: @escaping (Alamofire.DataResponse<RemoveReviewResult>) -> Void)
}
