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
    private enum Columns {
        static let type = Column("type")
        static let sql = Column("sql")
    }
    
    enum Requests {
        static let tables = SQLiteMaster
            .all()
            .filter(Columns.type == RecordType.table.rawValue)
            .filter(literal: "name NOT LIKE 'sqlite\\_%' ESCAPE '\\'")
            .filter(literal: "name NOT LIKE 'grdb\\_%' ESCAPE '\\'")
        
        static let indexes = SQLiteMaster
            .all()
            .filter(Columns.type == RecordType.index.rawValue)
            .filter(Columns.sql != nil) // All user-created indexes have sql, only automatic have null sql
        
        static let triggers = SQLiteMaster
            .all()
            .filter(Columns.type == RecordType.trigger.rawValue)
        
        static let views = SQLiteMaster
            .all()
            .filter(Columns.type == RecordType.view.rawValue)
    }
}
