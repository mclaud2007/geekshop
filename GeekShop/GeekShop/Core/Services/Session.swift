//
//  Session.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 15.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation

class Session {
    static var shared = Session()
    private(set) var userInfo: UserResult?
    var currentUserId: Int? {
        return userInfo?.idUser
    }
    
    func setUserInfo(_ info: UserResult) {
        self.userInfo = info
    }
    
    func kill() {
        self.userInfo = nil
    }
}
