//
//  UserProfileVerifier.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 09.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//
// swiftlint:disable control_statement

import Foundation
import UIKit

class ProfileVerifier {
    var requiredFields: [UITextField: UILabel]
    
    init(requiredFields: [UITextField: UILabel]) {
        self.requiredFields = requiredFields
    }
    
    func reset() {
        requiredFields.forEach { (_, label: UILabel) in
            label.isHidden = true
        }
    }
    
    func check() {
        requiredFields.forEach { (txtField: UITextField, lblError: UILabel) in
            if (txtField.text == nil || txtField.text?.isEmpty == true) {
                lblError.isHidden = false
            }
        }
    }
}
