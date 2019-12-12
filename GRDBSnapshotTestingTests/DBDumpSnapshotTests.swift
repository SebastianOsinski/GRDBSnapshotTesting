//
//  DBDumpSnapshotTests.swift
//  GRDBSnapshotTestingTests
//
//  Created by Sebastian Osiński on 11/12/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import XCTest
import GRDB
import SnapshotTesting
import GRDBSnapshotTesting

class DBDumpSnapshotTests: XCTestCase {
    private let db = DatabaseQueue()
    
    private let record = false
    
    func testSnapshotOnlyTables() throws {
        try applyExampleMigration(db: db, migration: ExampleMigrations.onlyTables)
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testSnapshotWithIndexes() throws {
        try applyExampleMigration(db: db, migration: ExampleMigrations.withIndexes)
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testSnapshotWithIndexesAndTriggers() throws {
        try applyExampleMigration(db: db, migration: ExampleMigrations.withIndexesAndTriggers)
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    func testSnapshotWithData() throws {
        try applyExampleMigration(db: db, migration: ExampleMigrations.withData)
        
        assertSnapshot(matching: db, as: .dbDump, record: record)
    }
    
    private func applyExampleMigration(db: DatabaseQueue, migration: @escaping (Database) throws -> Void) throws {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("exampleMigration", migrate: migration)
        try migrator.migrate(db)
    }
}
