import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
//    let dbPath = DirectoryConfiguration.detect().workingDirectory + "db.sqlite"
//    print(dbPath)
//    app.databases.use(.sqlite(.file(dbPath)), as: .sqlite)
//    app.migrations.add(UserList(username: "test", password: "12345", firstName: "Test", lastName: "Test", email: "email@test.ru"))

    // register routes
    try routes(app)
}
