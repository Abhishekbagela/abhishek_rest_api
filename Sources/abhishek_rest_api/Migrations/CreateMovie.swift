import FluentKit

struct CreateMovie: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("movies")
            .id()
            .field("title", .string, .required)
            .field("genre", .string, .required)
            .field("year", .int, .required)
            .field("director", .string, .required)
            .field("overview", .custom("TEXT"))
            .field("poster_path", .string)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("movies").delete()
    }
}
