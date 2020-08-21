//
//  Application.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 16.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import UIKit

final class AppManager {
    static let shared = AppManager()
    let session = Session()
    
    var window: UIWindow?
    var rootViewController: UIViewController?

    func start(_ window: UIWindow? = nil) {
        if let window = window {
            self.window = window
            configure()
        }
        
        return
    }
    
    private func configure() {
        // Инициализируем контроллеры
        let catalog = getScreenPage(storyboard: "Catalog", identifier: "catalogScreen")
        let profile = getScreenPage(storyboard: "Users", identifier: "profileScreen")
        let basket = getScreenPage(storyboard: "Catalog", identifier: "basketScreen")
        
        // Инициализируем билдер таббара
        let tabBarBuilder = TabBarBuilder()

        // Добавляем контроллер каталога
        tabBarBuilder.addNavController(viewController: catalog, title: "Каталог",
                                image: "folder", selectedImage: "folder.fill")
        
        // Добавляем контроллер корзины
        tabBarBuilder.addNavController(viewController: basket, title: "Корзина",
                                       image: "cart", selectedImage: "cart.fill")
        
        // Добавляем контроллер профиля
        tabBarBuilder.addNavController(viewController: profile, title: "Профиль",
                                image: "person", selectedImage: "person.fill")
        
        // Создаем таббар
        let tabBar = tabBarBuilder.build()
        self.rootViewController = tabBar
        
        // Устанавливаем рут вью котнроллер
        window?.rootViewController = self.rootViewController
        window?.makeKeyAndVisible()
    }
    
    func getScreenPage(storyboard name: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier)
    }
}
