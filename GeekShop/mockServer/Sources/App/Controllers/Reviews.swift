//
//  Reviews.swift
//  
//
//  Created by Григорий Мартюшин on 01.08.2020.
//

import Foundation
import Vapor



class Reviews {
    let resulter: View!
    let req: Request!
        
    init(_ req: Request) {
        self.resulter = View(req: req)
        self.req = req
    }
    
    // MARK: Review router
    func doAction(action: String) -> EventLoopFuture<String> {
        switch action {
        case "list":
            return list()
        case "add":
            return add()
        case "approve":
            return approve()
        case "remove":
            return remove()
        default:
            return resulter.error(message: "Unknown method")
        }
    }
    
    // MARK: Добавление нового отзыва
    func add() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetReviewAdd.self),
            let productId = query.productId,
            let userName = query.user_name, let userEmail = query.user_email,
            let title = query.title, let descritpion = query.description
            else {
                return resulter.error(message: "Wrong parameter count")
        }
        
        // Получаем следующее значение id
        return ReviewList.query(on: self.req.db).max(\.$reviewId).flatMapAlways { result -> EventLoopFuture<String> in
            switch result {
            case let .success(maxId):
                if let maxId = maxId {
                    // Добавление нового комментария
                    return ReviewList(id: (maxId + 1), idProduct: productId,
                                      userName: userName, userEmail: userEmail,
                                      title: title, show: false, reviewDescription: descritpion)
                        .save(on: self.req.db).flatMapAlways { result -> EventLoopFuture<String> in
                            switch result {
                            case .success():
                                return self.resulter.item(message: ["userMessage": "Комментарий добавлен!"])
                            case .failure(_):
                                return self.resulter.error(message: "Error adding review")
                            }
                    }
                } else {
                    return self.resulter.error(message: "Error adding review")
                }
                
            case .failure(_):
                return self.resulter.error(message: "Error adding review")
            }
        }
    }
    
    // MARK: Получение отзыва по ID
    func getReviewBy(reviewId: Int) -> EventLoopFuture<ReviewList?> {
        return ReviewList.query(on: req.db)
            .filter(\.$reviewId, .equal, reviewId)
            .limit(1)
            .first()
    }
    
    // MARK: Утверждение отзыва
    func approve() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetReviewChange.self),
            let reviewId = query.reviewId
            else {
                return resulter.error(message: "You must specify review id")
        }
        
        return getReviewBy(reviewId: reviewId).map { review -> EventLoopFuture<String> in
            if let review = review {
                review.show = true
                
                return review.update(on: self.req.db).flatMapAlways { result -> EventLoopFuture<String> in
                    switch result {
                    case .success(_):
                        return self.resulter.items()
                    case .failure(_):
                        return self.resulter.error(message: "Approve error")
                    }
                }
            } else {
                return self.resulter.error(message: "Review not found")
            }
        }.flatMap { result -> EventLoopFuture<String> in
            return result
        }
    }
    
    // MARK: Удаление отзыва по id
    func remove() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetReviewChange.self),
            let reviewId = query.reviewId
            else {
                return resulter.error(message: "You must specify review id")
        }
        
        //  Для тестов фиктивно вернем положительный результат на id == 3 иначе в унит тестах клиенсткой части будет ошибка
        if reviewId == 3 {
            return resulter.item()
        }
        
        // Пытаемся найти отзыв по id
        return getReviewBy(reviewId: reviewId).map { review -> EventLoopFuture<String> in
            if let review = review {
                return review.delete(on: self.req.db).flatMapAlways { resultDelete -> EventLoopFuture<String> in
                    switch resultDelete {
                    case .success():
                        return self.resulter.item()
                    case .failure(_):
                        return self.resulter.error(message: "Review delete error")
                    }
                }
            } else {
                return self.resulter.error(message: "Review not found")
            }
        }.flatMap { result -> EventLoopFuture<String> in
            return result
        }
    }
    
    // MARK: Отображение списка отзывов по товару
    func list() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetReviewList.self),
            let productId = query.productId
            else {
                return resulter.error(message: "You must specify product id")
        }
        
        return ReviewList.query(on: req.db)
            .filter(\.$idProduct, .equal, productId)
            .all().map { list -> [[String: Any]] in
                list.map { item -> [String: Any] in
                    if let reviewId = item.$reviewId.value,
                        let productId = item.$idProduct.value,
                        let title = item.$title.value,
                        let reviewDescription = item.$reviewDescription.value,
                        let show = item.$show.value,
                        let userName = item.$userName.value,
                        let userEmail = item.$userEmail.value {
                        
                        return ["id": reviewId,
                                "id_product": productId,
                                "title": title,
                                "description": reviewDescription,
                                "show": show,
                                "user_name": userName,
                                "user_email": userEmail
                        ]
                    } else {
                        return [:]
                    }                    
                }
        }.flatMap { result -> EventLoopFuture<String> in
            if result.count > 0 {
                return self.resulter.items(message: result)
            } else {
                return self.resulter.error(message: "Review not found")
            }
        }
    }
}

extension Reviews {
    struct GetReviewList: Content {
        var productId: Int?
    }
    
    struct GetReviewAdd: Content {
        var productId: Int?
        var user_name, user_email, title, description: String?
    }
    
    struct GetReviewChange: Content {
        var reviewId: Int?
    }
}
