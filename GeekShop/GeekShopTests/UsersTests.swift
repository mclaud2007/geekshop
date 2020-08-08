//
//  UsersTests.swift
//  GeekShopTests
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import XCTest
import Alamofire
@testable import GeekShop

enum UsersApiErrorStub: Error {
    case fatalError
}

struct ErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return UsersApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class UsersTests: XCTestCase {
    let exectation = XCTestExpectation(description: "UsersTests")
    var errorParser: ErrorParseStub!
    let sessionManager = SessionManager(configuration: URLSessionConfiguration.default)
    var usersObject: Users!
    var timeout: TimeInterval = 10.0

    override func setUp() {
        errorParser = ErrorParseStub()
        usersObject = Users.init(errorParser: errorParser, sessionManager: sessionManager)
    }
    
    override func tearDown() {
        usersObject = nil
        errorParser = nil
    }

    func testLogin() {
        usersObject.loginWith(userLogin: "Somebody", userPassword: "Password") { [weak self] (response: DataResponse<LoginResult>) in
            switch response.result {
            case .success(let loginResult):
                if loginResult.authToken.isEmpty {
                   XCTFail("Autho token is empty")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        wait(for: [exectation], timeout: timeout)
    }
    
    func testLogout() {
        usersObject.logoutCurrentUser { [weak self] (response: DataResponse<LogoutResult>) in
            switch response.result {
            case .success(let logoutResult):
                if logoutResult.result != 1 {
                    XCTFail("Unknown LogoutResult")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        wait(for: [exectation], timeout: timeout)
    }
    
    func testRegister() {
        // Создаем экземпляр пользователя для регистрации
        let userToRegister = User(userId: nil, login: "test", password: "123456", email: "s@ivanov.com", firstName: "Sergey", lastName: "Ivanov")
        
        usersObject.registerUserWith(user: userToRegister) { [weak self] (response: DataResponse<RegisterResult>) in
            switch response.result {
            case .success(let registerResult):
                if registerResult.result != 1 {
                    XCTFail("Unknown registerResult")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testChangeUserData() {
        let userToChange = User(userId: 1, login: "test", password: "54321", email: "i@sergeev.com", firstName: "Ivan", lastName: "Sergeev")
        
        usersObject.changeUserFrom(user: userToChange) { [weak self] (response: DataResponse<ChangeUserDataResult>) in
            switch response.result {
            case .success(let changeUserDataResult):
                if changeUserDataResult.result != 1 {
                    XCTFail("Unknown ChangeUserDataResult")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }

}
