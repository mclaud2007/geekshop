//
//  TabBarBuilder.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 16.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import UIKit

final class TabBarBuilder {
    // MARK: Propertie
    private var tabs = [UIViewController]()
    
    // MARK: Methods
    public func addNavController(viewController: UIViewController, title: String?, image: String?, selectedImage: String?) {
        let tabNavController = UINavigationController()
        let tabNavControllerIcon = UITabBarItem(title: title,
                                                image: (image != nil ? UIImage(systemName: image!) : nil),
                                                selectedImage: (selectedImage != nil ? UIImage(systemName: selectedImage!) : nil)
        )
        
        tabNavController.tabBarItem = tabNavControllerIcon
        tabNavController.viewControllers = [viewController]
        tabs.append(tabNavController)
    }
    
    public func getActiveControllerFrom(controller: UITabBarController) -> UIViewController? {
        let selectIndex = controller.selectedIndex
        
        if let viewControllers = controller.viewControllers,
            viewControllers.count <= selectIndex {
            return viewControllers[selectIndex]
        }
        
        return nil
    }
    
    public func build() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = tabs
                
        return tabBarController
    }
}
