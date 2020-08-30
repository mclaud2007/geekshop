//
//  Snapshot.swift
//  GeekShopUITests
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
        let _ = app.tabBars.buttons["Каталог"].tap()
        snapshot("Catalog")
        
        let _ = app.staticTexts["Razer Basilisk Ultimate"].tap()
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
        
        let passwordLabel = app.secureTextFields["lblPassword"]
        passwordLabel.tap()
        
        let tKey = app.keys["t"]
        let eKey = app.keys["e"]
        let sKey = app.keys["s"]
        
        // Пароль
        tKey.tap()
        eKey.tap()
        sKey.tap()
        tKey.tap()
        
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
        let _ = app.tabBars.buttons["Профиль"].tap()
        snapshot("Profile")
        
        // Выходим и делаем еще один скриншот
        app/*@START_MENU_TOKEN@*/.staticTexts["Выход"]/*[[".buttons[\"Выход\"].staticTexts[\"Выход\"]",".staticTexts[\"Выход\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Logout")
    }

}
