//
//  ChangeRequestFactory.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 19.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import Alamofire

protocol ChangeUserDataRequestFactory {
    func doChange(login: String,
                  password: String,
                  firstName: String,
                  lastName: String?,
                  email: String,
                  completionHandler: @escaping (DataResponse<ChangeUserDataResult>) -> Void) -> Void
}
