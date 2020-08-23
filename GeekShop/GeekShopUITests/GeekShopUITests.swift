//
//  GeekShopUITests.swift
//  GeekShopUITests
//
//  Created by Григорий Мартюшин on 18.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import XCTest

class GeekShopUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
    }
        
    func testLoginOk() throws {
        app.launch()

        // Перейдем на вкладку профиль
        app.tabBars.buttons["Профиль"].tap()
        let elementsQuery = app.scrollViews.otherElements
        let loginLabel = app.textFields["lblLogin"]
        
        // Ждем пока не появится доступ к запрошенному полю
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: loginLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        loginLabel.tap()
        loginLabel.typeText("test")

        let passwordLabel = elementsQuery.secureTextFields["lblPassword"]
        passwordLabel.tap()
        
        let tKey = app.keys["t"]
        let eKey = app.keys["e"]
        let sKey = app.keys["s"]
        
        // Пароль
        tKey.tap()
        eKey.tap()
        sKey.tap()
        tKey.tap()
        
        let btnEnter = elementsQuery.buttons["btnEnter"]
        btnEnter.tap()
        
        let lblEmail = app.otherElements["lblEmail"].children(matching: .other).element.children(matching: .textField).element
        
        // Ждем пока не появится доступ к запрошенному полю
        expectation(for: exists, evaluatedWith: lblEmail, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(lblEmail.value as? String, "i@sergeev.com")
        
    }
    
    // Тест будет пройден когда появится ALERT с ошибкой (т.е. вход на самом деле не удастсья)
    func testLoginFail() throws {
        app.launch()

        // Перейдем на вкладку профиль
        app.tabBars.buttons["Профиль"].tap()
        let elementsQuery = app.scrollViews.otherElements
        let loginLabel = app.textFields["lblLogin"]
        
        // Ждем пока не появится доступ к запрошенному полю
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: loginLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        loginLabel.tap()
        loginLabel.typeText("fail")

        let passwordLabel = elementsQuery.secureTextFields["lblPassword"]
        passwordLabel.tap()
        
        let tKey = app.keys["t"]
        let eKey = app.keys["e"]
        let sKey = app.keys["s"]
        
        // Пароль
        tKey.tap()
        eKey.tap()
        sKey.tap()
        tKey.tap()
        
        let btnEnter = app.buttons["btnEnter"]
        btnEnter.tap()
                
        let token = addUIInterruptionMonitor(withDescription: "При попытке входа произошла ошибка") { alert in
            alert.buttons["Ok"].tap()
            return true
        }
        
        RunLoop.current.run(until: Date(timeInterval: 2, since: Date()))
        
        app.tap()
        removeUIInterruptionMonitor(token)
        
        let lblEmail = app.textFields["lblEmail"]
        let nonExists = NSPredicate(format: "exists == 0")
        expectation(for: nonExists, evaluatedWith: lblEmail, handler: nil)
        
        // Успешно пройден
        waitForExpectations(timeout: 5, handler: nil)
        
    }
}
