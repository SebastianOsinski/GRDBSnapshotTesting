//
//  DatabaseQueue.swift
//  GRDBSnapshotTesting
//
//  Created by Sebastian Osiński on 11/12/2019.
//

import GRDB

extension DatabaseQueue {
    public static func inMemoryDatabase(fromPath path: String, configuration: Configuration = Configuration()) throws -> DatabaseQueue {
        try DatabaseQueue(path: path).inMemoryCopy(configuration: configuration)
    }
}
