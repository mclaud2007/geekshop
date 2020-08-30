//
//  ReviewsTests.swift
//  GeekShopTests
//
//  Created by Григорий Мартюшин on 01.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import XCTest
import Alamofire
@testable import GeekShop

enum ReviewsApiErrorStub: Error {
    case fatalError
}

struct ReviewsErrorParserStub: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return ReviewsApiErrorStub.fatalError
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        return error
    }
}

class ReviewsTests: XCTestCase {
    let expecation = XCTestExpectation(description: "ReviewsTests")
    var errorParser: ReviewsErrorParserStub!
    let sessionManager = SessionManager(configuration: URLSessionConfiguration.default)
    var reviewObject: Reviews!
    var timeout: TimeInterval = 10.0

    override func setUp() {
        errorParser = ReviewsErrorParserStub()
        reviewObject = Reviews.init(errorParser: errorParser, sessionManager: sessionManager)
    }
    
    override func tearDown() {
        errorParser = nil
        reviewObject = nil
    }

    func testGetReviewList() {
        reviewObject.getReviewsForProductBy(productId: 1) { [weak self] (response: DataResponse<GetReviewsResult>) in
            switch response.result {
            case .success(let reviews):
                if reviews.isEmpty {
                    XCTFail("Reviews is empty")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testAddReview() {
        let addReviewModel = Review(reviewId: nil, productId: nil,
                                    userName: "Test", userEmail: "test@mail.ru",
                                    title: "Test", description: "Some review")
        
        reviewObject.addReviewForProductBy(productId: 1, review: addReviewModel) { [weak self] (response: DataResponse<AddReviewResult>) in
            switch response.result {
            case .success(let addResult):
                if addResult.result != 1 {
                    XCTFail("Something went wrong")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testApproveReview() {
        reviewObject.setReviewApporoveBy(reviewId: 3) { [weak self] (response: DataResponse<ApproveReviewResult>) in
            switch response.result {
            case .success(let approveResult):
                if approveResult.result != 1 {
                    XCTFail("Something went wrong")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }
    
    func testRemoveReview() {
        reviewObject.removeReviewBy(reviewId: 3) { [weak self] (respone: DataResponse<RemoveReviewResult>) in
            switch respone.result {
            case .success(let removeResult):
                if removeResult.result != 1 {
                    XCTFail("Something went wrong")
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            self?.expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: timeout)
    }

}
