import Fluent
import Vapor
import VaporToOpenAPI

func routes(_ app: Application) throws {
    app.get { req async in
        """
        Welcome to the Abhishek Rest API! 🚀
        
        Available Endpoints:
        - GET  /movies          : List all movies (synced from external API)
        - GET  /users           : List all users
        - GET  /images          : List all images
        - GET  /lifecycle/status : Check server & database health
        - GET  /swagger         : View interactive API documentation
        - GET  /openapi.json    : Download OpenAPI specification
        """
    }
    
    try app.register(collection: UserController())
    try app.register(collection: MovieController())
    try app.register(collection: ImageController())
    try app.register(collection: LifecycleController())

    // OpenAPI JSON
    app.get("openapi.json") { req in
        app.routes.openAPI(
            info: .init(
                title: "Abhishek Rest API",
                description: "Vapor based REST API with MySQL and External Data Integration",
                version: "1.0.0"
            )
        )
    }

    // Swagger UI
    app.get("swagger") { req -> Response in
        let html = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Swagger UI</title>
            <link rel="stylesheet" type="text/css" href="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui.css">
            <style>
                html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
                *, *:before, *:after { box-sizing: inherit; }
                body { margin: 0; background: #fafafa; }
            </style>
        </head>
        <body>
            <div id="swagger-ui"></div>
            <script src="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui-bundle.js"></script>
            <script src="https://unpkg.com/swagger-ui-dist@5.11.0/swagger-ui-standalone-preset.js"></script>
            <script>
            window.onload = function() {
                const ui = SwaggerUIBundle({
                    url: "/openapi.json",
                    dom_id: '#swagger-ui',
                    deepLinking: true,
                    presets: [
                        SwaggerUIBundle.presets.apis,
                        SwaggerUIStandalonePreset
                    ],
                    plugins: [
                        SwaggerUIBundle.plugins.DownloadUrl
                    ],
                    layout: "StandaloneLayout"
                });
                window.ui = ui;
            };
            </script>
        </body>
        </html>
        """
        return Response(status: .ok, headers: ["Content-Type": "text/html"], body: .init(string: html))
    }
}



