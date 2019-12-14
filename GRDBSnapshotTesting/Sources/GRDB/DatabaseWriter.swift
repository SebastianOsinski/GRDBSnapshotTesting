import GRDB

extension DatabaseWriter {
    public func inMemoryCopy(configuration: Configuration = Configuration()) throws -> DatabaseQueue {
        let copy = DatabaseQueue(configuration: configuration)
        
        try self.backup(to: copy)
        
        return copy
    }
}
