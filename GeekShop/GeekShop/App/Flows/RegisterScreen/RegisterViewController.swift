//
//  RegisterViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 08.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//
import UIKit

class RegisterViewController: UIViewController, TrackableMixin {
    // MARK: Outlets
    @IBOutlet weak var fieldEmail: TextFieldView! {
        didSet {
            fieldEmail.fieldContentType = .emailAddress
        }
    }
    
    @IBOutlet weak var fieldPassword: TextFieldView! {
        didSet {
            fieldPassword.fieldContentType = .password
            fieldPassword.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var fieldNewPassword: TextFieldView! {
        didSet {
            fieldNewPassword.fieldContentType = .password
            fieldNewPassword.isSecureTextEntry = true
            fieldNewPassword.fieldErrorTitle = "Поле не совпадает"
        }
    }
    
    @IBOutlet weak var fieldFirstName: TextFieldView!
    @IBOutlet weak var fieldLastName: TextFieldView!
    
    let userFactory = RequestFactory().makeUsersFactory()
    var verifier: FormVerifier!
    
    var userLogin: String?
    var userPassword: String?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Регистрация"
        
        // По клику на вью будет убираться клавиатура
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewClicked))
        view.addGestureRecognizer(tapGesture)
        
        // Инициализируем класс проверки данных пользователя
        verifier = FormVerifier(required: [fieldEmail, fieldPassword, fieldNewPassword, fieldFirstName])
    }
    
    @objc private func viewClicked() {
        view.endEditing(true)
    }
    
    // MARK: Methods
    @IBAction func btnRegisterClicked(_ sender: Any) {
        // Для начала выключаем все строки с ошибками, если они были - дальше будем включать обратно
        verifier.reset()

        // Выводим сообщения об ошибках
        verifier.check()

        // Унврапим опционалы
        guard let email = fieldEmail.fieldValue, !email.isEmpty,
            let password = fieldPassword.fieldValue, !password.isEmpty,
            let newPassword = fieldNewPassword.fieldValue,
            let firstName = fieldFirstName.fieldValue, !firstName.isEmpty else {
                return
        }

        // Проверяем совпалили пароли
        guard password == newPassword else {
            fieldNewPassword.error()
            return
        }

        // Создаем структуру нового пользователя
        let newUser = User(userId: nil, login: email, password: password,
                           email: email, firstName: firstName,
                           lastName: fieldLastName.fieldValue
        )

        // На данном этапе все необходимые сведенья существуют - можно регистрировать пользователя
        userFactory.registerUserWith(user: newUser) { response in
            switch response.result {
            case let .success(registerResult):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: registerResult.userMessage, title: "Успех") { [weak self] _ in
                        guard let self = self else {
                            return
                        }
                        
                        // Регистрация нового пользователя
                        self.track(.registration)

                        //  Возвращаем на экран логина
                        self.dismiss(animated: true)
                    }
                }

            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "Ошибка регистрации")
                }
            }
        }
    }

    @IBAction func btnCancelClicked(_ sender: Any) {
        //  Возвращаем на экран логина
        self.dismiss(animated: true)
    }
}
