//
//  Analytics.swift
//  GeekShop
//
//  Created by Григорий Мартюшин on 22.08.2020.
//  Copyright © 2020 Григорий Мартюшин. All rights reserved.
//

import Foundation
import FirebaseAnalytics
typealias AnalyticsParam = [String: Any]?

enum AnalyticsEvent {
    case login(success: Bool)
    case logout
    case addToBasekt(param: AnalyticsParam)
    case cleanBasket
    case payBasket(param: AnalyticsParam)
    case addNewReview
    case openProductPage(param: AnalyticsParam)
    case openCatalogPage(param: AnalyticsParam)
    case registration
}

protocol TrackableMixin {
    func track(_ event: AnalyticsEvent)
}

extension TrackableMixin {
    func track(_ event: AnalyticsEvent) {
        switch event {
        case let .login(success):
            if success {
                Analytics.logEvent("loginSuccess", parameters: nil)
            } else {
                Analytics.logEvent("loginFailed", parameters: nil)
            }
        case let .addToBasekt(param):
            Analytics.logEvent("addToBasket", parameters: param)
        case .cleanBasket:
            Analytics.logEvent("basketWasCleaned", parameters: nil)
        case let .payBasket(param: param):
            Analytics.logEvent("payingSuccesfull", parameters: param)
        case .addNewReview:
            Analytics.logEvent("addNewReview", parameters: nil)
        case let .openProductPage(param):
            Analytics.logEvent("productPageWasOpenned", parameters: param)
        case let .openCatalogPage(param):
            Analytics.logEvent("catalogWasOpenned", parameters: param)
        case .registration:
            Analytics.logEvent("newUserWasRegister", parameters: nil)
        case .logout:
            Analytics.logEvent("logout", parameters: nil)
        }
    }
}
