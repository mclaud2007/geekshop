//
//  LoginScreenController.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 08.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//
// swiftlint:disable empty_enum_arguments

import UIKit

class LoginScreenController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var scrollContainer: UIScrollView!
    
    // MARK: Properties
    let userFactory = RequestFactory().makeUsersFactory()
    var userId: Int?
    var authToken: String?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // По клику на вью убираем клавиатуру
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewClicked(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Второе - когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
                                               
        // На странице входа нам не нужен навигейшенбар
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Отписываемся от уведомлений
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Methods
    // Скрывает клавиатуру по клику на вью
    @objc func viewClicked(_ sender: UIView) {
        view.endEditing(true)
        scrollViewReset()
    }
    
    // Вызываетя когда появляется клавиатура и отодвигает поля для ввода выше
    @objc func keyboardWasShown(notification: Notification) {
        // Выясняем размер клавиатуры
        guard let info = notification.userInfo as NSDictionary?,
              let kbSizeInfo = info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
                return
        }

        let kbSize = kbSizeInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        // Добавляем отступ внизу UISCrollView
        scrollContainer.contentInset = contentInsets
        scrollContainer.scrollIndicatorInsets = contentInsets
        scrollContainer.contentOffset = CGPoint(x: 0, y: kbSize.height)
    }
    
    // Вызывается когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        scrollViewReset()
    }
    
    // Метод сбрасвающий скрол в скролвью
    fileprivate func scrollViewReset() {
        // Устанавливаем отступ внизу UISCrollView равный 0
        scrollContainer.contentInset = UIEdgeInsets.zero
        scrollContainer.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollContainer.contentOffset = CGPoint.zero
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        guard let login = txtLogin.text, let password = txtPassword.text,
            !login.isEmpty, !password.isEmpty else {
                self.showErrorMessage(message: "Необходимо ввести пароль")
                return
        }
                
        userFactory.loginWith(userLogin: login, userPassword: password) { response in
            switch response.result {
            case .success(let login):
                DispatchQueue.main.async {
                    self.userId = login.user.idUser
                    self.authToken = login.authToken
                    
                    self.performSegue(withIdentifier: "enter", sender: self)
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.showErrorMessage(message: "При попытке входа произошлка ошибка")
                }                
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Если запросили регистрацию, проверим не заполнено ли поле логин, если да перекинем на новую форму
        if segue.identifier == "register", let destination = segue.destination as? RegisterViewController {
            destination.userLogin = txtLogin.text
            destination.userPassword = txtPassword.text
        } else if segue.identifier == "enter", let destination = segue.destination as? UITabBarController {
            if let profile = destination.viewControllers?.first as? ProfileViewController {
                profile.userId = userId
            }            
            
        }
        
        // А также для всех переходов - надо вернуть навигацию
        navigationController?.navigationBar.isHidden = false
        
        // При любом переходе со страницы логина очищаем поля
        txtLogin.text = nil
        txtPassword.text = nil
    }

}
