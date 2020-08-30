import Vapor

func routes(_ app: Application) throws {
    
    app.get { req in
        return View(req: req).error(message: "Forbidden")
    }

    app.get("users", ":action") { req -> EventLoopFuture<String> in
        if let action = req.parameters.get("action") {
            return Users(req).doAction(action: action)
        } else {
            return View(req: req).error(message: "You must specify method")
        }
    }
    
    app.get("catalog", ":action") { req -> EventLoopFuture<String> in
        if let action = req.parameters.get("action") {
            return Catalog(req).doAction(action: action)
        } else {
            return View(req: req).error(message: "You must specify method")
        }
    }
    
    app.get("reviews", ":action") { req -> EventLoopFuture<String> in
        if let action = req.parameters.get("action") {
            return Reviews(req).doAction(action: action)
        } else {
            return View(req: req).error(message: "You must specify method")
        }
    }
    
    app.get("basket", ":action") { req -> EventLoopFuture<String> in
        if let action = req.parameters.get("action") {
            return Basket(req).doAction(action: action)
        } else {
            return View(req: req).error(message: "You must specify method")
        }
    }
}
