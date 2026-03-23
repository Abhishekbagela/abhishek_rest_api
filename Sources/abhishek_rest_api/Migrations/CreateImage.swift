import FluentKit

struct CreateImage: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("images")
            .id()
            .field("name", .string, .required)
            .field("url", .string, .required)
            .field("type", .string, .required)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("images").delete()
    }
}
