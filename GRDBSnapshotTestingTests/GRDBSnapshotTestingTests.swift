import XCTest
import GRDB
import SnapshotTesting
import GRDBSnapshotTesting

class GRDBSnapshotTestingTests: XCTestCase {
    private let db = DatabaseQueue()
    
    private let record = false
    
    func testEmptyDatabase() throws {
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testOneTable() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testTwoTables() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testOneIndex() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.BookAuthorIdIndex.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testTwoIndexes() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.BookAuthorIdIndex.self,
            Migrations.AuthorCountryIndex.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testOneTrigger() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.AuthorUpdateTrigger.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testTwoTriggers() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.AuthorUpdateTrigger.self,
            Migrations.BookUpdateTrigger.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testOneView() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.AuthorsPerCountryView.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testTwoViews() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.AuthorsPerCountryView.self,
            Migrations.BooksPerAuthorView.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testVirtualTable() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.DocumentVirtualTable.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testData() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.Data.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testAll() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.AuthorTable.self,
            Migrations.BookTable.self,
            Migrations.BookAuthorIdIndex.self,
            Migrations.AuthorCountryIndex.self,
            Migrations.BookUpdateTrigger.self,
            Migrations.AuthorsPerCountryView.self,
            Migrations.BooksPerAuthorView.self,
            Migrations.DocumentVirtualTable.self,
            Migrations.Data.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testTablesWithSQLiteKeywordNamesAreSnapshottedWithoutError() throws {
        try applyMigrations(db: db, migrations: [
            Migrations.SQLiteKeywordTableNames.self
        ])
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    private func applyMigrations(db: DatabaseQueue, migrations: [DBMigration.Type]) throws {
        var migrator = DatabaseMigrator()
        
        for migration in migrations {
            migrator.registerMigration(migration.name, migrate: migration.migrate)
        }
        
        try migrator.migrate(db)
    }
}
