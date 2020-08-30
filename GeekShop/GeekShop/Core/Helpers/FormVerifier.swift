//
//  FormVerifier.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 22.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

class FormVerifier {
    private var requiredFields: [TextFieldView] = []
    
    init(required fields: [TextFieldView]) {
        requiredFields = fields
    }
    
    func check() {
        requiredFields.filter { $0.isRequired == true }
            .forEach { field in
                if field.fieldValue == nil || field.fieldValue == "" {
                    field.error()
                }
        }
    }
    
    func reset() {
        requiredFields.forEach { field in
            field.reset()
        }
    }
}
