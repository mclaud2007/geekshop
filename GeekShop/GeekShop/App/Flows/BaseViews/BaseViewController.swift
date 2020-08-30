//
//  NeedLogin.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 16.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import UIKit

protocol NeedLoginDelegate: class {
    func didReloadData()
    func willDisappear()
}

class BaseViewController: UIViewController {
    // id текущего пользователя
    var userId: Int? {
        return AppManager.shared.session.userInfo?.idUser
    }
    
    // Необходима ли авторизция
    var isNeedLogin: Bool {
        return userId == nil
    }
    
    weak var delegate: NeedLoginDelegate?
    var app = AppManager.shared
    
    public func login(delegate: NeedLoginDelegate?) {
        if let needLogin = AppManager.shared.getScreenPage(storyboard: "Users",
                                             identifier: "loginScreen") as? BaseViewController {
            needLogin.delegate = delegate
            needLogin.modalPresentationStyle = .overFullScreen
            present(needLogin, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.willDisappear()
    }
}

//protocol NeedLogin: UIViewController {
//    var userId: Int? { get }
//    var isNeedLogin: Bool { get }
//
//    func nlRealodData()
//}
//
//extension NeedLogin {
//    var isNeedLogin: Bool {
//        if userId == nil {
//            return true
//        }
//
//        return false
//    }
//
//    func popLogin() {
//        let needLogin = AppManager.shared.getScreenPage(storyboard: "Users", identifier: "needEnterScreen")
//        needLogin.modalPresentationStyle = .overCurrentContext
//        needLogin.title = "Need login"
//
//        present(needLogin, animated: false)
//    }
//}
