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
    }
    
    override func tearDown() {
        errorParser = nil
        basketObject = nil
    }
    
    func testGetBasket() {
        basketObject.getBasketBy(sessionId: 123) { [weak self] (response: DataResponse<GetBasketResult>) in
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
    
    func testAddToBasket() {
        basketObject.addProductToBasketBy(productId: 123, sessionId: 123, quantity: 2) { [weak self] (response: DataResponse<AddToBasketResult>) in
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
    
    func testRemoveFromBasket() {
        basketObject.removeProductFromBasketBy(productId: 456, sessionId: 123) { [weak self] (response: DataResponse<RemoveFromBasketResult>) in
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
    
    func testPayOrder() {
        basketObject.payOrderBy(sessionId: 123, paySumm: 2000) { [weak self] (response: DataResponse<PayOrderResult>) in
            switch response.result {
            case .success(let payOrderResult):
                if payOrderResult.result != 1 {
                    XCTFail("Fail to pay")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }

}
