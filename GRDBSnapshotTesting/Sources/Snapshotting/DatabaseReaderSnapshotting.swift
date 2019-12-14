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
    /// Snapshot strategy for comparing databases based on dump representation.
    static let dbDump = _dump()
}

public extension Snapshotting where Value == DatabasePool, Format == String {
    /// Snapshot strategy for comparing databases based on dump representation.
    static let dbDump = _dump()
}
