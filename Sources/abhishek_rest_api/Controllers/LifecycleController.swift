import Vapor
import Fluent
import SQLKit
import VaporToOpenAPI

struct LifecycleController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let lifecycle = routes.grouped("lifecycle")
        
        lifecycle.get("status", use: status)
            .openAPI(tags: "Lifecycle", summary: "Check server and database status")
            
        lifecycle.post("stop", use: stop)
            .openAPI(tags: "Lifecycle", summary: "Shut down the server")
            
        lifecycle.post("restart", use: restart)
            .openAPI(tags: "Lifecycle", summary: "Restart the server")
    }

    // GET /lifecycle/status
    @Sendable
    func status(req: Request) async throws -> [String: String] {
        do {
            if let sql = req.db as? any SQLDatabase {
                try await sql.raw("SELECT 1").run()
                return ["status": "Healthy", "database": "Connected"]
            } else {
                return ["status": "Healthy", "database": "Non-SQL Database"]
            }
        } catch {
            return ["status": "Degraded", "database": "Disconnected", "error": "\(error)"]
        }
    }

    // POST /lifecycle/stop
    @Sendable
    func stop(req: Request) async throws -> HTTPStatus {
        req.logger.info("Shutdown requested via API")
        
        // Schedule shutdown after a short delay to allow response to be sent
        req.eventLoop.scheduleTask(in: .seconds(1)) {
            req.application.shutdown()
        }
        
        return .ok
    }
    
    // POST /lifecycle/restart
    @Sendable
    func restart(req: Request) async throws -> HTTPStatus {
        req.logger.info("Restart requested via API")
        
        // With 'restart: always' in Docker, shutting down will trigger a restart
        req.eventLoop.scheduleTask(in: .seconds(1)) {
            req.application.shutdown()
        }
        
        return .ok
    }
}
