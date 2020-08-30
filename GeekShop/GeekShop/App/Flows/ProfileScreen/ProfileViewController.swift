//
//  ProfileScreenViewController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 09.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
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
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var lblNeedEnterTitle: UILabel!
    @IBOutlet weak var btnEnter: UIButton!
    
    // MARK: Properties
    var userFactory = RequestFactory().makeUsersFactory()
    var verifier: FormVerifier!
    
    // MARK: Lifecycle    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Профиль"
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewClicked))
        view.addGestureRecognizer(tapRecognizer)
        
        // По-умолчанию кнопка сохранить не показана
        btnSave.isHidden = true
                        
        // Инициализируем класс проверки данных пользователя
        verifier = FormVerifier(required: [fieldEmail, fieldPassword, fieldNewPassword, fieldFirstName])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Пытаемся загрузить профиль или покажем сообщение что нужно войти
        if !isNeedLogin {
            loadProfile()
            
        } else {
            toggleProfileInterface(hide: true)
            login(delegate: self)
            
        }
    }
        
    private func loadProfile() {
        if let userId = userId {
            userFactory.getUserBy(userId: userId) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case let .success(userData):
                    DispatchQueue.main.async {
                        self.toggleProfileInterface(hide: false)
                        
                        // Пользователя найден - показываем кнопку сохранить и заполняем форму
                        self.fieldEmail.fieldValue = userData.userEmail
                        self.fieldFirstName.fieldValue = userData.firstName
                        self.fieldLastName.fieldValue = userData.lastName
                        self.fieldPassword.fieldValue = userData.userPassword
                        self.fieldNewPassword.fieldValue = userData.userPassword
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showErrorMessage(message: "Во время загрузки профиля произошла ошибка", title: "Ошибка")
                        
                    }
                }
            }
        }
    }
    
    private func toggleProfileInterface(hide: Bool = true) {
        fieldEmail.isHidden = hide
        fieldPassword.isHidden = hide
        fieldNewPassword.isHidden = hide
        fieldFirstName.isHidden = hide
        fieldLastName.isHidden = hide
        btnSave.isHidden = hide
        btnExit.isHidden = hide
        btnEnter.isHidden = !hide
        lblNeedEnterTitle.isHidden = !hide
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
        guard let email = fieldEmail.fieldValue, !email.isEmpty,
            let password = fieldPassword.fieldValue, !password.isEmpty,
            let newPassword = fieldNewPassword.fieldValue,
            let firstName = fieldFirstName.fieldValue, !firstName.isEmpty,
            let userId = userId else {
                return
        }
                
        // Проверяем совпалили пароли
        guard password == newPassword else {
            fieldNewPassword.error()
            return
        }
        
        // Собираем новую информацию для изменения
        let user = User(userId: userId, login: email,
                        password: password, email: email,
                        firstName: firstName, lastName: fieldLastName.fieldValue
        )
        
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
    
    @IBAction func btnEnter(_ sender: Any) {
        login(delegate: self)
    }
    
    @IBAction func btnExitClicked(_ sender: Any) {
        app.session.kill()
        
        if !isNeedLogin {
            loadProfile()
        } else {
            toggleProfileInterface(hide: true)
        }
    }
}

extension ProfileViewController: NeedLoginDelegate {
    func didReloadData() {
        loadProfile()
    }
    
    func willDisappear() {
        toggleProfileInterface(hide: true)
    }
    
}
