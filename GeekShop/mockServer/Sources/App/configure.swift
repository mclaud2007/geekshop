import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.migrations.add(UserList())
    app.migrations.add(CatalogList())
    app.migrations.add(ReviewList())
    app.migrations.add(Baskets())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
