//
//  AppDelegate.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 18.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let requestFactory = RequestFactory()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let users = requestFactory.makeUsersFactory()

        // Регистрация пользователя
        users.registerUserWith(firstName: "Sergey", lastName: "Ivanov", userLogin: "test", userPassword: "12345", userEmail: "s@ivanov.com") { response in
            switch response.result {
            case .success(let register):
                print(register)
                break
            case .failure(let error):
                print(error)
                break
            }
        }

        // Login
        users.loginWith(userLogin: "Somebody", userPassword: "Password") { response in
            switch response.result {
            case .success(let login):
                print(login)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        // logout
        users.logoutCurrentUser {  response in
            switch response.result {
            case .success(let logout):
                print(logout)
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }

        // ChangeData
        users.changeUserDataBy(id: 1, firstName: "Ivan", lastName: "Sergeev", userLogin: "test", userPassword: "12345", userEmail: "s@ivanov.ru") { response in
            switch response.result {
            case .success(let change):
                print(change)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
        let catalog = requestFactory.makeCatalogFactory()

        catalog.productsList { response in
            switch response.result {
            case .success(let catalogResult):
                print(catalogResult)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        catalog.productBy(id: 123) { response in
            switch response.result {
            case .success(let catalogResult):
                print(catalogResult)
                break
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

