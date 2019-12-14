import GRDB

struct SQLiteMaster: Decodable, FetchableRecord, TableRecord {
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case tableName = "tbl_name"
        case sql
    }
    
    enum RecordType: String, Decodable {
        case table
        case index
        case trigger
        case view
    }
    
    static let databaseTableName = "sqlite_master"
    
    let type: RecordType
    let name: String
    let tableName: String?
    let sql: String
}

extension SQLiteMaster {
    enum Requests {
        static let tables = SQLiteMaster
            .all()
            .filter(Column("type") == RecordType.table.rawValue)
        
        static let indexes = SQLiteMaster
            .all()
            .filter(Column("type") == RecordType.index.rawValue)
            .filter(Column("sql") != nil) // All user-created indexes have sql, only automatic have null sql
        
        static let triggers = SQLiteMaster
            .all()
            .filter(Column("type") == RecordType.trigger.rawValue)
        
        static let views = SQLiteMaster
            .all()
            .filter(Column("type") == RecordType.view.rawValue)
    }
}
