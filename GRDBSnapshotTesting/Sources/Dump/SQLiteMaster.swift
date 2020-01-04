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
        static let name = Column("name")
    }
    
    enum Requests {
        private static func objects(type: RecordType) -> QueryInterfaceRequest<SQLiteMaster> {
            return SQLiteMaster
                .all()
                .filter(Columns.type == type.rawValue)
                .filter(literal: "name NOT LIKE 'sqlite\\_%' ESCAPE '\\'")
                .filter(literal: "name NOT LIKE 'grdb\\_%' ESCAPE '\\'")
                .order(Columns.name.asc)
        }
        
        static let tables = objects(type: .table)
        
        static let indexes = objects(type: .index)
            .filter(Columns.sql != nil) // All user-created indexes have sql, only automatic have null sql
        
        static let triggers = objects(type: .trigger)
        
        static let views = objects(type: .view)
    }
}
