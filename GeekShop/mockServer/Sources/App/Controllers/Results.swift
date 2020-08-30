//
//  Results.swift
//  
//
//  Created by Григорий Мартюшин on 28.07.2020.
//

import Foundation
import Vapor

class View {
    let req: Request
    
    init(req: Request) {
        self.req = req
    }
    
    func error (_ message: String) -> String {
        return "{\"result\": 0, \"error\": \"\(message)\"}"
    }
    
    func items(_ res: [Dictionary<String,Any>]? = nil) -> String {
        if let res = res {            
            if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [.withoutEscapingSlashes, .prettyPrinted]),
                let jsonString = String(data: jsonData, encoding: .utf8)
            {
                return jsonString
            } else {
                return error("unknown error")
            }
        } else {
            return " {\"result\": 1} "
        }
    }
    
    func item(_ res: Dictionary<String,Any>? = nil) -> String {
        if var res = res {            
            res["result"] = 1
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [.withoutEscapingSlashes, .prettyPrinted]),
                let jsonString = String(data: jsonData, encoding: .utf8)
            {
                return jsonString
            } else {
                return error("unknown error")
            }
        } else {
            return " {\"result\": 1} "
        }
    }
    
    func error(message: String) -> EventLoopFuture<String> {
        return req.eventLoop.makeSucceededFuture(error(message))
    }
    
    func item(message: Dictionary<String,Any>? = nil) -> EventLoopFuture<String> {
        return req.eventLoop.makeSucceededFuture(item(message))
    }
    
    func items(message: [Dictionary<String,Any>]? = nil) -> EventLoopFuture<String> {
        return req.eventLoop.makeSucceededFuture(items(message))
    }
}
