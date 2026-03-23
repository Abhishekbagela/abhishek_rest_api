import Vapor
import Fluent
import FluentMySQLDriver
import NIOSSL
import VaporToOpenAPI

    // configures your application
    public func configure(_ app: Application) async throws {

    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let port = Environment.get("DATABASE_PORT").flatMap(Int.init) ?? 3306
    let username = Environment.get("DATABASE_USERNAME") ?? "vapor_user"
    let password = Environment.get("DATABASE_PASSWORD") ?? "123456"
    let database = Environment.get("DATABASE_NAME") ?? "common_db"

    app.databases.use(
        .mysql(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: database,
            tlsConfiguration: .none
        ),
        as: .mysql
    )
    
    // HTTPS Configuration
    if let certPath = Environment.get("CERT_PATH"), let keyPath = Environment.get("KEY_PATH") {
        do {
            let certificates = try NIOSSLCertificate.fromPEMFile(certPath).map { NIOSSLCertificateSource.certificate($0) }
            let privateKey = try NIOSSLPrivateKeySource.privateKey(NIOSSLPrivateKey(file: keyPath, format: .pem))
            
            app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
                certificateChain: certificates,
                privateKey: privateKey
            )
            app.http.server.configuration.port = 8080
        } catch {
            fatalError("Failed to load SSL certificates from \(certPath) and \(keyPath): \(error)")
        }
    }
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateMovie())
    app.migrations.add(CreateImage())
    
    // Auto-run migrations on boot
    try await app.autoMigrate()
    
    // register routes
    try routes(app)

    // Lifecycle: Auto-sync on boot
    app.lifecycle.use(MovieSyncLifecycle())
}

struct MovieSyncLifecycle: LifecycleHandler {
    func didBoot(_ application: Application) throws {
        Task {
            application.logger.info("Starting automatic movie sync on boot...")
            let dummyRequest = Request(application: application, on: application.eventLoopGroup.next())
            
            do {
                let status = try await MovieController().sync(req: dummyRequest)
                application.logger.info("Automatic movie sync completed with status: \(status)")
            } catch {
                application.logger.error("Automatic movie sync failed: \(error)")
            }
        }
    }
}
