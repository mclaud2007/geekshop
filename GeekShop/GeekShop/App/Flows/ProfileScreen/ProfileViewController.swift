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
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblEmailTitle: UILabel!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var lblPasswordTitle: UILabel!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var lblNewPasswordError: UILabel!
    @IBOutlet weak var lblNewPasswordTitle: UILabel!
        
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtFirstNameError: UILabel!
    @IBOutlet weak var lblFirstNameTitle: UILabel!
        
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblLastNameTitle: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet var btnExit: UIButton!
    @IBOutlet weak var btnEnter: UIButton!
    
    @IBOutlet weak var lblAuthorisationNeeded: UILabel!
    
    // MARK: Properties
    // Фабрика запросов
    var userFactory = RequestFactory().makeUsersFactory()
    var verifier: ProfileVerifier!
    
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
                                                    txtFirstName: txtFirstNameError])
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
        }
    }
    
    private func toggleProfileInterface(hide: Bool = true) {
        lblEmailError.isHidden = hide
        lblEmailTitle.isHidden = hide
        txtEmail.isHidden = hide
        
        lblPasswordError.isHidden = hide
        lblPasswordTitle.isHidden = hide
        txtPassword.isHidden = hide

        lblNewPasswordTitle.isHidden = hide
        lblNewPasswordError.isHidden = hide
        txtNewPassword.isHidden = hide

        lblFirstNameTitle.isHidden = hide
        txtFirstNameError.isHidden = hide
        txtFirstName.isHidden = hide

        lblLastNameTitle.isHidden = hide
        txtLastName.isHidden = hide

        btnExit.isHidden = hide
        btnEnter.isHidden = !hide
        lblAuthorisationNeeded.isHidden = !hide
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
            let firstName = txtFirstName.text, !firstName.isEmpty,
            let userId = userId else {
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
    
    @IBAction func btnEnter(_ sender: Any) {
        toggleProfileInterface(hide: true)
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
        self.toggleProfileInterface(hide: false)
        loadProfile()
    }
    
    func willDisappear() {
        self.toggleProfileInterface(hide: true)
    }
    
}
