//
//  FormTextField.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 22.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class FormTextField: UITextField {
    init(frame: CGRect, type: UITextContentType? = nil) {
        super.init(frame: frame)
        configure()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth = true
        textColor = UIColor.black.withAlphaComponent(0.87)
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
                
    }
}
