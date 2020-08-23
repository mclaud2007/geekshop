//
//  TextFieldView.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 22.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class TextFieldView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var lblFieldName: UILabel!
    @IBOutlet private weak var txtValue: UITextField!
    @IBOutlet private weak var lblFieldError: UILabel!
    
    @IBInspectable
    var fieldName: String {
        get {
            lblFieldName.text ?? "None"
        }
        
        set {
            lblFieldName.text = newValue
        }
    }
    
    let defaultErrorText = "Поле является обязательным"    
    
    @IBInspectable
    var fieldErrorTitle: String? {
        get {
            lblFieldError.text ?? defaultErrorText
        }
        
        set {
            lblFieldError.text = newValue ?? defaultErrorText
        }
    }
    
    var fieldContentType: UITextContentType? {
        get {
            txtValue.textContentType
        }
        
        set {
            txtValue.textContentType = newValue
        }
    }
    
    var isSecureTextEntry: Bool {
        get {
            txtValue.isSecureTextEntry
        }
        
        set {
            txtValue.isSecureTextEntry = newValue
        }
    }
    
    @IBInspectable
    var isRequired: Bool = false
    
    var fieldValue: String? {
        get {
            txtValue.text ?? ""
        }
        
        set {
            txtValue.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public func reset() {
        lblFieldError.isHidden = true
    }
    
    public func error() {
        lblFieldError.isHidden = false
    }
}
