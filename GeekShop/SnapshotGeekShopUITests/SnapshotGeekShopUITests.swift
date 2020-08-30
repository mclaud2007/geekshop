//
//  SnapshotGeekShopUITests.swift
//  SnapshotGeekShopUITests
//
//  Created by Григорий Мартюшин on 25.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import XCTest

class SnapshotGeekShopUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
       
    func testMakeSnapshot() throws {
        // Use recording to get started writing UI tests.
        app.tabBars.buttons["Каталог"].tap()
        snapshot("Catalog")
        
        app.staticTexts["Razer Basilisk Ultimate"].tap()
        snapshot("Product")
        
        // Добавялем в корзину товар
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Добавить в корзину"].tap()
        
        // Поле с паролем
        let loginLabel = app.textFields["lblLogin"]
        
        // Ждем пока не появится доступ к запрошенному полю
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: loginLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Делаем скриншот экрана входа
        snapshot("Login")
        loginLabel.tap()
        loginLabel.typeText("test")
        app.staticTexts["Пароль"].tap()
        sleep(2)
        
        let passwordLabel = app.secureTextFields["lblPassword"]
        sleep(2)
        passwordLabel.tap()
        passwordLabel.typeText("test")
        sleep(2)
        
        // Нажать вход
        let btnEnter = elementsQuery.buttons["btnEnter"]
        btnEnter.tap()
        
        // Переходим в корзину
        let basket = app.tabBars.buttons["Корзина"]
        expectation(for: exists, evaluatedWith: basket, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        basket.tap()
        
        // Делаем скриншот
        snapshot("Basket")
        
        // Переходим в профиль для скриншота
        app.tabBars.buttons["Профиль"].tap()
        snapshot("Profile")
        
        // Выходим и делаем еще один скриншот
        app.staticTexts["Выход"].tap()
        snapshot("Logout")
    }
}
