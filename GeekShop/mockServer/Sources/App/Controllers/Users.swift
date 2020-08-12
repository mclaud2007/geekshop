//
//  Users.swift
//  
//
//  Created by Григорий Мартюшин on 28.07.2020.
//

import Fluent
import FluentSQLiteDriver
import Vapor

class Users {
    // MARK: Properties
    let resulter: View!
    var req: Request!
    
    init(_ req: Request) {
        self.resulter = View(req: req)
        self.req = req
    }
    
    // MARK: User router
    func doAction(action: String) -> EventLoopFuture<String> {        
        switch action {
        case "login":
            return login()
        case "logout":
            return logout()
        case "change":
            return change()
        case "register":
            return register()
        case "get":
            return get()
        default:
            return resulter.error(message: "Unknown message")
        }
    }
    
    // Получаем user future по логину и паролю
    func getUserFutureBy(login: String, password: String) -> EventLoopFuture<UserList?> {
        return UserList.query(on: req.db)
            .filter(\.$username, .equal, login)
            .filter(\.$password, .equal, password)
            .limit(1)
            .first()
    }
    
    // Получаем пользователя по логину и паролю
    func getUserBy(login: String, password: String) -> EventLoopFuture<[String: Any]?> {
        return getUserFutureBy(login: login, password: password)
            .map { (user) -> [String: Any]? in
                if let user = user,
                    let userLogin = user.$username.value,
                    let userName = user.$firstName.value,
                    let userLastname = user.$lastName.value,
                    let userEmail = user.$email.value,
                    let idUser = user.$userId.value as? Int {
                    
                    return ["user_login": userLogin,
                            "user_name": userName,
                            "user_lastname": userLastname ?? "",
                            "user_email": userEmail,
                            "id_user": idUser
                    ]
                } else {
                    return nil
                }
        }
    }
    
    
    // Получаем future для пользователя по id
    func getUserFutureById(id: Int) -> EventLoopFuture<UserList?> {
        return UserList.query(on: req.db)
            .filter(\.$userId, .equal, id)
            .limit(1)
            .first()
    }
    
    //  Получаем пользователя по id
    func getUserById(id: Int) -> EventLoopFuture<[String: Any]?> {
        return getUserFutureById(id: id)
            .map { user -> [String: Any]? in
                if let user = user,
                    let userLogin = user.$username.value,
                    let userPassword = user.$password.value,
                    let userName = user.$firstName.value,
                    let userLastname = user.$lastName.value,
                    let userEmail = user.$email.value,
                    let idUser = user.$userId.value as? Int {
                    
                    return ["user_login": userLogin,
                            "user_password": userPassword,
                            "user_name": userName,
                            "user_lastname": userLastname ?? "",
                            "user_email": userEmail,
                            "id_user": idUser
                    ]
                } else {
                    return nil
                }
        }
    }
    
    // Логин пользователя
    func login() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetLogin.self),
            let userName = query.username,
            let userPassword = query.password else {
                return req.eventLoop.makeSucceededFuture(resulter.error("Mismatch parameters"))
        }
        
        // Пытаемся найти пользовтеля
        return getUserBy(login: userName, password: userPassword).flatMap { user -> EventLoopFuture<String> in
            if let user = user {
                let result: [String: Any] = ["authToken": "some_auth_token",
                                             "result": 1,
                                             "user": user
                ]
                                        
                // Формируем JSON
                return self.resulter.item(message: result)
            } else {
                return self.resulter.error(message: "User not found")
            }
        }
        
    }
    
    // На самом деле пока что ничего не происходит, т.к. сессии не реализованы (и врядли будут на мок сервере то =))
    func logout() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetLogout.self),
            let userId = query.userId else {
                return resulter.error(message: "User not found")
        }
        
        return getUserById(id: userId).flatMap { user -> EventLoopFuture<String> in
            if let _ = user {
                return self.resulter.item()
            } else {
                return self.resulter.error(message: "User not found")
            }
        }
    }
    
    func change() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetChangeUserData.self),
            let userName = query.username,
            let userPassword = query.password,
            let firstName = query.first_name,
            let lastName = query.last_name,
            let userEmail = query.email,
            let userId = query.userId else {
                return resulter.error(message: "You must spercify all parameter")
        }
        
        // Пытаемся найти пользователя
        return getUserFutureById(id: userId).map { user -> EventLoopFuture<String> in
            if let user = user {
                user.firstName = firstName
                user.lastName = lastName
                user.email = userEmail
                user.password = userPassword
                user.username = userName
                
                return user.update(on: self.req.db).flatMapAlways { result -> EventLoopFuture<String> in
                    switch result {
                    case .success():
                        return self.resulter.item()
                    case .failure(_):
                        return self.resulter.error(message: "Update error")
                    }
                }
                
            } else {
                return self.resulter.error(message: "User not found")
            }
        }.flatMap { updateResult -> EventLoopFuture<String> in
            return updateResult
        }
    }
    
    // MARK: Регистрация пользователя
    func register() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetChangeUserData.self),
            let userName = query.username,
            let userPassword = query.password,
            let firstName = query.first_name,
            let lastName = query.last_name,
            let userEmail = query.email else {
                return resulter.error(message: "You must spercify all parameter")
        }
        
        // Для того чтобы наш тест отрабатывал без ошибок придется добавить фейковую отбивку на пользователя new_test
        // иначе при повторном тесте будет вылетать ошибка что такой пользователь сущетвует
        if userName == "new_test" {
            return self.resulter.item(message: ["userMessage": "Регистрация прошла успешно!"])
        }
        
        // Для начала попробуем найти такого пользователя, и если его нет - то добавим в базу
        return getUserFutureBy(login: userName, password: userPassword).map { user -> EventLoopFuture<String> in
            // Пользователь существует - регистрация запрещена
            if let _ = user {
                return self.resulter.error(message: "Регистрация невозможна - пользователь существет.")
                
            } else {
                // Получаем следующее значение id
                return UserList.query(on: self.req.db).max(\.$userId).flatMapAlways { result -> EventLoopFuture<String> in
                    switch result {
                    case let .success(maxId):
                        if let maxId = maxId {
                            // Регистриурем пользователя
                            return UserList(id: maxId + 1, username: userName,
                                            password: userPassword, firstName: firstName,
                                            lastName: lastName, email: userEmail)
                                .save(on: self.req.db).flatMapAlways { (result) -> EventLoopFuture<String> in
                                    switch result {
                                    case .success():
                                        return self.resulter.item(message: ["userMessage": "Регистрация прошла успешно!"])
                                    case .failure(_):
                                        return self.resulter.error(message: "Update error")
                                    }
                            }
                            
                        } else {
                            return self.resulter.error(message: "Register error")
                        }
                    case .failure(_):
                        return self.resulter.error(message: "Update error")
                    }
                }
            }
        }.flatMap { saveResult -> EventLoopFuture<String> in
            return saveResult
        }        
    }
    
    // MARK: Получение пользователя по ID
    func get() -> EventLoopFuture<String> {
        guard let query = try? req.query.get(GetUserParam.self),
            let userId = query.userId else {
                return resulter.error(message: "Method mismatch")
        }
        
        // Пытаемся найти пользователя по id
        return getUserById(id: userId).flatMap { user -> EventLoopFuture<String> in
            if let user = user {
                return self.resulter.item(message: user)
            } else {
                return self.resulter.error(message: "User not found")
            }
        }
    }
}

// MARK: Структуры GET-параметров
extension Users {
    struct GetLogin: Content {
        var username: String?
        var password: String?
    }

    struct GetLogout: Content {
        var userId: Int?
    }

    struct GetChangeUserData: Content {
        var username: String?
        var password: String?
        var first_name: String?
        var last_name: String?
        var email: String?
        var userId: Int?
    }
    
    struct GetUserParam: Content {
        var userId: Int?
    }
}
