//
//  AppDelegate.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 18.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable line_length
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let requestFactory = RequestFactory()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let users = requestFactory.makeUsersFactory()
        
        // Создаем экземпляр пользователя для регистрации
        let userToRegister = User(userId: nil, login: "test", password: "123456", email: "s@ivanov.com", firstName: "Sergey", lastName: "Ivanov")
                
        // Регистрация пользователя
        users.registerUserWith(user: userToRegister) { response in
            print("User Registration")
            
            switch response.result {
            case .success(let register):
                print(register)
            case .failure(let error):
                print(error)
            }
        }
        
        // Login
        users.loginWith(userLogin: "Somebody", userPassword: "Password") { response in
            print("User login")
            
            switch response.result {
            case .success(let login):
                print(login)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // logout
        users.logoutCurrentUser {  response in
            print("User logout")
            
            switch response.result {
            case .success(let logout):
                print(logout)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let userToChange = User(userId: 1, login: "test", password: "54321", email: "i@sergeev.com", firstName: "Ivan", lastName: "Sergeev")

        // ChangeData
        users.changeUserFrom(user: userToChange) { response in
            print("User data change")
            
            switch response.result {
            case .success(let change):
                print(change)
            case .failure(let error):
                print(error)
            }
        }
        
        // Фабрика работы с каталогом
        let catalog = requestFactory.makeCatalogFactory()

        catalog.getProductsList { response in
            print("Product list")
            
            switch response.result {
            case .success(let catalogResult):
                print(catalogResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        catalog.getProductBy(productId: 123) { response in
            print("Product")
            
            switch response.result {
            case .success(let catalogResult):
                print(catalogResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //  Фабрика по работе с отзывами
        let reviews = requestFactory.makeReviewsFactory()
        
        reviews.getReviewsForProductBy(productId: 123) { response in
            print("Reviews to product")
            
            switch response.result {
            case .success(let reviewsResult):
                print(reviewsResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let reviewToAdd = Review(reviewId: nil, productId: nil,
                                 userName: "Sergey Ivanov", userEmail: "s@ivanov.com",
                                 title: "Отзыв на мышь", description: "Отличная, всем рекомендую!")
        
        reviews.addReviewForProductBy(productId: 123, review: reviewToAdd) { response in
            print("Add review")
            
            switch response.result {
            case .success(let reviewsAddResult):
                print(reviewsAddResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        reviews.setReviewApporoveBy(reviewId: 2) { response in
            print("Approve review")
            
            switch response.result {
            case .success(let reviewApprovalResult):
                print(reviewApprovalResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        reviews.removeReviewBy(reviewId: 2) { response in
            print("Remove review")
            
            switch response.result {
            case .success(let reviewRemovalResult):
                print(reviewRemovalResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //  Фабрика по работе с корзиной
        let basket = requestFactory.makeBasketFactory()
        
        // Получение корзины
        basket.getBasketBy(sessionId: 123) { response in
            print("Basket")
            
            switch response.result {
            case .success(let basketResult):
                print(basketResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Добавление товара в корзину
        basket.addProductToBasketBy(productId: 123, sessionId: 123, quantity: 2) { response in
            print("Add to basket")
            
            switch response.result {
            case .success(let addToBasketResult):
                print(addToBasketResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Удаление товара из корзины
        basket.removeProductFromBasketBy(productId: 123, sessionId: 123) { response in
            print("Remove from basket")
            
            switch response.result {
            case .success(let removeFromBasketResult):
                print(removeFromBasketResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Оплата корзины
        basket.payOrderBy(sessionId: 123, paySumm: 2000) { response in
            print("Pay basket")
            
            switch response.result {
            case .success(let payBasketResult):
                print(payBasketResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
