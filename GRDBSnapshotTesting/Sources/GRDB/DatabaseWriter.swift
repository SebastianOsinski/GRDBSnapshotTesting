import GRDB

extension DatabaseWriter {
    /// Returns in-memory `DatabaseQueue` with schema and data from `self`.
    /// - Parameter configuration: Database configuration
    public func inMemoryCopy(configuration: Configuration = Configuration()) throws -> DatabaseQueue {
        let copy = DatabaseQueue(configuration: configuration)
        
        try self.backup(to: copy)
        
        return copy
    }
}
