import GRDB

struct DatabaseDumper {
    private let database: DatabaseReader
    
    init(_ database: DatabaseReader) {
        self.database = database
    }
    
    func dump() throws -> String {
        var lines = [String]()
        
        try dumpCreateTables(lines: &lines)
        try dumpCreateIndexes(lines: &lines)
        try dumpCreateTriggers(lines: &lines)
        try dumpCreateViews(lines: &lines)
        try dumpData(lines: &lines)
        
        return lines.joined(separator: "\n")
    }
    
    private func dumpCreateTables(lines: inout [String]) throws {
        let tables = try database.read(SQLiteMaster.Requests.tables.fetchAll)
        
        lines.append(contentsOf: [header("TABLES")])
        
        guard !tables.isEmpty else {
            lines.append(placeholder("NO TABLES"))
            
            return
        }
        
        let createTables = tables
            .map(formatCreateTable)
            .flatMap { $0 + [""] }
        
        lines.append(contentsOf: createTables)
    }
    
    private func dumpCreateIndexes(lines: inout [String]) throws {
        let indexes = try database.read(SQLiteMaster.Requests.indexes.fetchAll)
        
        guard !indexes.isEmpty else { return }
        
        lines.append(contentsOf: [header("INDEXES")])
        
        let createIndexes = indexes
            .map(formatCreateIndex)
            .flatMap { $0 + [""] }
        
        lines.append(contentsOf: createIndexes)
    }
    
    private func dumpCreateTriggers(lines: inout [String]) throws {
        let triggers = try database.read(SQLiteMaster.Requests.triggers.fetchAll)
        
        guard !triggers.isEmpty else { return }
        
        lines.append(contentsOf: [header("TRIGGERS")])
        
        let createTriggers = triggers
            .map { $0.sql }
            .flatMap { [$0] + [""] }
        
        lines.append(contentsOf: createTriggers)
    }
    
    private func dumpCreateViews(lines: inout [String]) throws {
        let views = try database.read(SQLiteMaster.Requests.views.fetchAll)
        
        guard !views.isEmpty else { return }
        
        lines.append(contentsOf: [header("VIEWS")])
        
        let createViews = views
            .map { $0.sql }
            .flatMap { [$0] + [""] }
        
        lines.append(contentsOf: createViews)
    }
    
    private func dumpData(lines: inout [String]) throws {
        let tables = try database.read(SQLiteMaster.Requests.tables.fetchAll)
        
        lines.append(contentsOf: [header("DATA")])
        
        guard !tables.isEmpty else {
            lines.append(placeholder("NO DATA"))
            
            return
        }
        
        try tables.forEach { table in
            lines.append("")
            
            try dumpTable(table.name, lines: &lines)
        }
    }
    
    private func dumpTable(_ table: String, lines: inout [String]) throws {
        let rows = try database.read { try Row.fetchAll($0, sql: "SELECT * FROM \(table)") }
        
        lines.append(contentsOf: [subheader(table)])
        
        if rows.isEmpty {
            lines.append(placeholder("NO ROWS"))
        } else {
            lines.append(contentsOf: formatRows(rows))
        }
    }
    
    private func formatCreateTable(_ record: SQLiteMaster) -> [String] {
        precondition(record.type == .table)
        
        let indent = "  "
        
        var lines = [String]()
        
        let sql = record.sql
        let openParenIndex = sql.firstIndex(of: "(")! // Index of parenthesis after CREATE TABLE <table name>
    
        let create = String(sql[sql.startIndex...openParenIndex])
        
        lines.append(create)
        
        let columns = sql[openParenIndex...]
            .dropFirst()
            .dropLast()
            .split(separator: ",")
            .map { indent + String($0.trimmingCharacters(in: .whitespaces)) }
        
        lines.append(contentsOf: columns)
        
        lines.append(")")
        
        return lines
    }
    
    private func formatCreateIndex(_ record: SQLiteMaster) -> [String] {
        precondition(record.type == .index)
        
        return [
            record.sql
        ]
    }
    
    private func formatRows(_ rows: [Row]) -> [String] {
        return rows.map { row in
            "("
            +
            row
                .columnNames
                .map { row[$0] as DatabaseValue }
                .map { $0.description }
                .joined(separator: ", ")
            +
            ")"
        }
    }
    
    private func header(_ name: String) -> String {
        return "======== \(name) ========"
    }
    
    private func subheader(_ name: String) -> String {
        return "## \(name)"
    }
    
    private func placeholder(_ name: String) -> String {
        return "<\(name)>"
    }
}
