//
//  Reviews.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 01.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

class Reviews: AbstractRequestFactory {
    var errorParser: AbstractErrorParser
    var sessionManager: SessionManager
    var queue: DispatchQueue?
    let baseUrl = URL(string: "http://127.0.0.1:8080/reviews/")!
    
    init(errorParser: AbstractErrorParser,
         sessionManager: SessionManager,
         queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Reviews: ReviewsRequestFactory {
    func getReviewsForProductBy(productId: Int, completion: @escaping (DataResponse<GetReviewsResult>) -> Void) {
        let requestModel = ReviewData(baseUrl: baseUrl, productId: productId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func addReviewForProductBy(productId: Int, review: Review, completion: @escaping (DataResponse<AddReviewResult>) -> Void) {
        let requestModel = ReviewDataAdd(baseUrl: baseUrl,
                                         productId: productId,
                                         userName: review.userName, userEmail: review.userEmail,
                                         title: review.title, description: review.description)
        
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func setReviewApporoveBy(reviewId: Int, completion: @escaping (DataResponse<ApproveReviewResult>) -> Void) {
        let requestModel = ReviewDataApprove(baseUrl: baseUrl, reviewId: reviewId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
    func removeReviewBy(reviewId: Int, completion: @escaping (DataResponse<RemoveReviewResult>) -> Void) {
        let requestModel = ReviewDataRemove(baseUrl: baseUrl, reviewId: reviewId)
        self.request(request: requestModel, completionHandler: completion)
    }
    
}
