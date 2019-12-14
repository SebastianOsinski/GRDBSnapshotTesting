import GRDB

extension DatabaseQueue {
    /// Creates in-memory `DatabaseQueue` with schema and data copied from database at `path`.
    /// - Parameters:
    ///   - path: Path to database file
    ///   - configuration: Database configuration.
    public static func inMemoryDatabase(fromPath path: String, configuration: Configuration = Configuration()) throws -> DatabaseQueue {
        return try DatabaseQueue(path: path).inMemoryCopy(configuration: configuration)
    }
}
