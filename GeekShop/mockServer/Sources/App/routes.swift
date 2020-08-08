import Vapor

func routes(_ app: Application) throws {
    let resulter = ShowResults()
    
    app.get { req in
        return resulter.returnError(message: "Forbidden")
    }

    app.get("users", ":action") { req -> String in
        if let action = req.parameters.get("action") {
            return Users().doAction(action: action, queryString: req.query)
        } else {
            return resulter.returnError(message: "You must specify method")
        }
    }
    
    app.get("catalog", ":action") { req -> String in
        if let action = req.parameters.get("action") {
            return Catalog().doAction(action: action, queryString: req.query)
        } else {
            return resulter.returnError(message: "You must specify method")
        }
    }
    
    app.get("reviews", ":action") { req -> String in
        if let action = req.parameters.get("action") {
            return Reviews().doAction(action: action, queryString: req.query)
        } else {
            return resulter.returnError(message: "You must specify method")
        }
    }
    
    app.get("basket", ":action") { req -> String in
        if let action = req.parameters.get("action") {
            return Basket().doAction(action: action, queryString: req.query)
        } else {
            return resulter.returnError(message: "You must specify method")
        }
    }
}
