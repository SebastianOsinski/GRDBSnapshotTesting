//
//  Migrations.swift
//  GRDBSnapshotTestingTests
//
//  Created by Sebastian Osiński on 12/12/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import GRDB

enum ExampleMigrations {
    static func onlyTables(db: Database) throws {
        try db.create(table: "author") { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("name", .text).notNull()
            t.column("country", .text).notNull()
        }
        
        try db.create(table: "book") { t in
            t.autoIncrementedPrimaryKey("id")
            t.column("title", .text).notNull()
            t.column("authorId", .integer).notNull().references("author", onDelete: .cascade)
            t.column("lastUpdate", .datetime)
        }
    }
    
    static func withIndexes(db: Database) throws {
        try onlyTables(db: db)
        
        try db.create(index: "book_authorId", on: "book", columns: ["authorId"])
        try db.create(index: "author_country", on: "author", columns: ["country"])
    }
    
    static func withIndexesAndTriggers(db: Database) throws {
        try withIndexes(db: db)
        
        try db.execute(sql: """
            CREATE TRIGGER book_update
                AFTER UPDATE ON book
                WHEN NEW.lastUpdate = OLD.lastUpdate
                BEGIN
                    UPDATE place SET lastUpdate = CURRENT_TIMESTAMP WHERE id = NEW.id;
                END
        """)
    }
    
    static func withData(db: Database) throws {
        try withIndexesAndTriggers(db: db)
        
        try db.execute(sql: """
        INSERT INTO author VALUES (1, 'J.K. Rowling', 'UK');
        INSERT INTO author VALUES (2, 'J.R.R. Tolkien', 'UK');
        
        INSERT INTO book VALUES (1, 'Harry Potter and the Philosopher''s Stone', 1, NULL);
        INSERT INTO book VALUES (2, 'Harry Potter and the Chamber of Secrets', 1, NULL);
        INSERT INTO book VALUES (3, 'Harry Potter and the Prisoner of Azkaban', 1, NULL);

        INSERT INTO book VALUES (4, 'The Hobbit', 2, NULL);
        INSERT INTO book VALUES (5, 'The Fellowship of the Ring', 2, NULL);
        """)
    }
}
