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
        let auth = requestFactory.makeAuthRequestFactory()
        
        auth.login(userName: "Somebody", password: "mypassword") { response in
            switch response.result {
            case .success(let login):
                print(login)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Logout
        auth.logout { response in
            switch response.result {
            case .success(let logout):
                print(logout)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Регистрация пользователя
        let register = requestFactory.makeRegisterRequestFactory()
        register.doRegister(login: "test", password: "12345", firstName: "Sergey", lastName: "Ivanov", email: "s@ivanov.com") { response in
            switch response.result {
            case .success(let register):
                print(register)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Изменение данных
        let change = requestFactory.makeChangeUserDataRequestFactory()
        change.doChange(login: "test", password: "123456", firstName: "Ivan", lastName: "Sergeev", email: "s@ivanov") { response in
            switch response.result {
            case .success(let change):
                print(change)
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

