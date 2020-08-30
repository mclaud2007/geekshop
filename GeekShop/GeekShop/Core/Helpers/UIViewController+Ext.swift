//
//  UIViewController+Ext.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 08.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorMessage (message: String, title: String? = "Ошибка", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
