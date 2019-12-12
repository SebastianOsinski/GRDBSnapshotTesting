//
//  DatabaseWriter.swift
//  GRDBSnapshotTesting
//
//  Created by Sebastian Osiński on 11/12/2019.
//

import GRDB

extension DatabaseWriter {
    public func inMemoryCopy(configuration: Configuration = Configuration()) throws -> DatabaseQueue {
        let copy = DatabaseQueue(configuration: configuration)
        
        try self.backup(to: copy)
        
        return copy
    }
}
