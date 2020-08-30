//
//  AddReviewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 15.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class AddReviewController: BaseViewController, TrackableMixin {
        
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblUserNameError: UILabel!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var lblTitleError: UILabel!
    
    @IBOutlet weak var txtReview: UITextView!
    @IBOutlet weak var lblReviewError: UILabel!
        
    let reviewFabric = RequestFactory().makeReviewsFactory()
    
    var product: ProductResult?
    var productID: Int?
    var verifier: ProfileVerifier!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавлем имя пользователя и email, если есть
        if let userName = app.session.userInfo?.userName {
            txtUserName.text = userName
            
            // Может у пользователя заполнена и фамилия
            if let userLastName = app.session.userInfo?.userLastname {
                txtUserName.text = (txtUserName.text ?? "") + " " + userLastName
            }
        }
        
        if let userEmail = app.session.userInfo?.userEmail {
            txtEmail.text = userEmail
        }
        
        // Если передали информацию о товаре, то заполним заголовк отзыва из названия продукта
        if let product = product {
            txtTitle.text = "Отзыв о " + product.productName
        }
        
        // Инициализируем класс проверки данных с отзывом
        verifier = ProfileVerifier(requiredFields: [txtUserName: lblUserNameError,
                                                    txtEmail: lblEmailError,
                                                    txtTitle: lblTitleError]
        )
        
        // Добавляем рамку вокруг поля добавления отзыва
        txtReview.layer.borderWidth = 1
        txtReview.layer.borderColor = UIColor.systemGray3.cgColor
        txtReview.layer.cornerRadius = 8
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNeedLogin {
            let needLogin = app.getScreenPage(storyboard: "Users", identifier: "needEnterScreen")
            needLogin.modalPresentationStyle = .currentContext
            show(needLogin, sender: self)
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        // Для начала сбросим все предыдущие проверки
        verifier.reset()
        lblReviewError.isHidden = true
        
        // Выводим сообщения об ошибках
        verifier.check()
        
        if txtReview.text.isEmpty {
            lblReviewError.isHidden = false
        }
        
        // Unwrap options value
        guard let userName = txtUserName.text,
            let userEmail = txtEmail.text,
            let title = txtTitle.text,
            let reviewText = txtReview.text,
            let pID = productID else {
                return
        }
        
        // Формируем структуру для добавления отзыва
        let review = Review(reviewId: nil, productId: pID,
                            userName: userName, userEmail: userEmail,
                            title: title, description: reviewText)
        
        // Добавляем отзыв
        reviewFabric.addReviewForProductBy(productId: pID, review: review) { [weak self] response in
            guard let self = self else {
                return
            }
            
            switch response.result {
            case .success(_):
                DispatchQueue.main.async {
                    self.track(.addNewReview)                    
                    self.dismiss(animated: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Добавить отзыв не получилось")
                }                
            }
        }
    }
    
    func nlRealodData() { }
    
}
