//
//  RegisterViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 08.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//
import UIKit

class RegisterViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.text = userLogin
        }
    }
    @IBOutlet weak var lblEmailError: UILabel!
    
    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            txtPassword.text = userPassword
        }
    }
    @IBOutlet weak var lblPasswordError: UILabel!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var lblNewPasswordError: UILabel!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var lblFirstNameError: UILabel!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    let userFactory = RequestFactory().makeUsersFactory()
    var verifier: ProfileVerifier!
    
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
        verifier = ProfileVerifier(requiredFields: [txtEmail: lblEmailError,
                                                    txtPassword: lblPasswordError,
                                                    txtNewPassword: lblNewPasswordError,
                                                    txtFirstName: lblFirstNameError])
        
        // По нажатию "Ввод" на клавиатуре будем делать тоже самое
        txtFirstName.delegate = self
        txtNewPassword.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtLastName.delegate = self
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
        
        // Создаем структуру нового пользователя
        let newUser = User(userId: nil, login: email, password: password,
                           email: email, firstName: firstName,
                           lastName: txtLastName.text
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

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
