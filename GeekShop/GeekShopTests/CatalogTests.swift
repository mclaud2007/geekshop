//
//  CatalogTests.swift
//  GeekShopTests
//
//  Created by Григорий Мартюшин on 25.07.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import XCTest
import Alamofire
@testable import GeekShop

enum CatalogApiErrorStub: Error {
    case fatalError
}

struct CatalogErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return CatalogApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class CatalogTests: XCTestCase {
    let exectation = XCTestExpectation(description: "CatalogTests")
    let sessionManager = SessionManager(configuration: URLSessionConfiguration.default)
    
    var catalogObject: Catalog!
    var errorParser: CatalogErrorParserStub!
    
    var timeout: TimeInterval = 10.0
    
    override func setUp() {
        errorParser = CatalogErrorParserStub()
        catalogObject = Catalog(errorParser: errorParser, sessionManager: sessionManager)
    }
    
    override func tearDown() {
        errorParser = nil
        catalogObject = nil
    }

    func testCatalogData() {
        catalogObject.productsList() { [weak self] (response: DataResponse<CatalogResult>) in
            switch response.result {
            case .success(let productResult):
                if productResult.count == 0 {
                    XCTFail("No products return")
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }
    
    func testGoodById() {
        catalogObject.productBy(id: 1234) { [weak self] (response: DataResponse<ProductResult>) in
            switch response.result {
            case .success(let goodResult):
                if goodResult.productDescription.isEmpty {
                    XCTFail("No product description")
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.exectation.fulfill()
        }
        
        wait(for: [exectation], timeout: timeout)
    }

}
