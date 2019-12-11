//
//  DatabaseReaderSnapshotting.swift
//  GRDB.swift
//
//  Created by Sebastian Osiński on 11/12/2019.
//

import SnapshotTesting
import GRDB

extension Snapshotting where Value: DatabaseReader, Format == String {
    static func _dump() -> Snapshotting {
        return SimplySnapshotting.lines.pullback { (database: DatabaseReader) in
            do {
                return try DatabaseDumper(database).dump()
            } catch {
                return "Error: " + error.localizedDescription
            }
        }
    }
}

public extension Snapshotting where Value == DatabaseQueue, Format == String {
    static let dbDump = _dump()
}

public extension Snapshotting where Value == DatabasePool, Format == String {
    static let dbDump = _dump()
}
