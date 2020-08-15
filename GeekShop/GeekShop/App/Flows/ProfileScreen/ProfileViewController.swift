//
//  ProfileScreenViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 09.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var lblNewPasswordError: UILabel!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtFirstNameError: UILabel!
    
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblFirstNameError: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    // MARK: Properties
    // Фабрика запросов
    var userFactory = RequestFactory().makeUsersFactory()
    var verifier: ProfileVerifier!

    // Идентификатор пользователя, который должен быть передан при загрузке экрана
    var userId: Int?

    // MARK: Lifecycle    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Профиль"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewClicked))
        view.addGestureRecognizer(tapRecognizer)
        
        // По-умолчанию кнопка сохранить не показана
        btnSave.isHidden = true
        
        // Инициализируем класс проверки данных пользователя
        verifier = ProfileVerifier(requiredFields: [txtEmail: lblEmailError,
                                                    txtPassword: lblPasswordError,
                                                    txtNewPassword: lblNewPasswordError,
                                                    txtFirstName: lblFirstNameError])
        
        if let userId = userId {
            userFactory.getUserBy(userId: userId) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case let .success(userData):
                    DispatchQueue.main.async {
                        // Пользователя найден - показываем кнопку сохранить и заполняем форму
                        self.btnSave.isHidden = false
                        self.txtEmail.text = userData.userEmail
                        self.txtFirstName.text = userData.firstName
                        self.txtLastName.text = userData.lastName
                        self.txtPassword.text = userData.userPassword
                        self.txtNewPassword.text = userData.userPassword
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Во время загрузки профиля произошла ошибка", title: "Ошибка")
                        
                    }
                }
            }
        } else {
            showErrorMessage(message: "Пользователь не найден", title: "Ошибка") { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    // MARK: Method
    @objc func viewClicked() {
        view.endEditing(true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        // Сбросим старые значения
        verifier.reset()
        
        // Проверим заполненость данных
        verifier.check()
        
        // Унврапим опционалы
        guard let email = txtEmail.text, !email.isEmpty,
            let password = txtPassword.text, !password.isEmpty,
            let newPassword = txtNewPassword.text,
            let firstName = txtFirstName.text, !firstName.isEmpty else {
                return
        }
                
        // Проверяем совпалили пароли
        guard password == newPassword else {
            lblNewPasswordError.isHidden = false
            return
        }
        
        // Собираем новую информацию для изменения
        let user = User(userId: userId, login: email, password: password, email: email, firstName: firstName, lastName: txtLastName.text)
        
        userFactory.changeUserFrom(user: user) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Изменения сохранены", title: "Успех")
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Ошибка сохранения изменений")
                }                
            }
        }
    }
}
