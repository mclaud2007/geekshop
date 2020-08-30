//
//  BasketTests.swift
//  GeekShopTests
//
//  Created by Григорий Мартюшин on 04.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//
// swiftlint:disable empty_enum_arguments

import XCTest
import Alamofire
@testable import GeekShop

enum BasketApiErrorStub: Error {
    case fatalError
}

struct BasketErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return BasketApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class BasketTests: XCTestCase {
    let expecation = XCTestExpectation(description: "BasketTests")
    var errorParser: BasketErrorParserStub!
    let sessionManager = SessionManager(configuration: URLSessionConfiguration.default)
    var basketObject: Basket!
    var timeout: TimeInterval = 10.0
    
    override func setUp() {
        errorParser = BasketErrorParserStub()
        basketObject = Basket.init(errorParser: errorParser, sessionManager: sessionManager)
        
        // Добавляем тестовый товар
        basketObject.addProductToBasketBy(productId: 1, userId: 1, quantity: 1) { _ in }
    }
    
    override func tearDown() {
        // Очищаем корзину
//        basketObject.clearBasketFrom(userId: 1) { _ in  }
        errorParser = nil
        basketObject = nil
    }
    
    func testAddToBasket() {
        basketObject.addProductToBasketBy(productId: 1, userId: 1, quantity: 1) { [weak self] (response: DataResponse<AddToBasketResult>) in
            switch response.result {
            case .success(let addToBasket):
                if addToBasket.result != 1 {
                    XCTFail("Fail add to basket")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testGetBasket() {
        basketObject.getBasketBy(userId: 1) { [weak self] (response: DataResponse<GetBasketResult>) in
            switch response.result {
            case .success(_):
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testPayOrder() {
        basketObject.payOrderBy(userId: 1, paySumm: 14990) { [weak self] (response: DataResponse<PayOrderResult>) in
            switch response.result {
            case .success(_):
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testRemoveFromBasket() {
        basketObject.removeProductFromBasketBy(productId: 1, userId: 1) { [weak self] (response: DataResponse<RemoveFromBasketResult>) in
            switch response.result {
            case .success(let removeFromBasket):
                if removeFromBasket.result != 1 {
                    XCTFail("Fail to remove from basket")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }

}
