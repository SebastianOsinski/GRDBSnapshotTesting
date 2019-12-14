import GRDB

protocol DBMigration {
    static var name: String { get }
    
    static func migrate(db: Database) throws
}

extension DBMigration {
    static var name: String {
        return String(describing: self)
    }
}

enum Migrations {
    enum AuthorTable: DBMigration {
        static func migrate(db: Database) throws {
            try db.create(table: "author") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("country", .text).notNull()
                t.column("lastUpdate", .datetime)
            }
        }
    }
    
    enum BookTable: DBMigration {
        static func migrate(db: Database) throws {
            try db.create(table: "book") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("authorId", .integer).notNull().references("author", onDelete: .cascade)
                t.column("lastUpdate", .datetime)
            }
        }
    }
    
    enum BookAuthorIdIndex: DBMigration {
        static func migrate(db: Database) throws {
            try db.create(index: "book_authorId", on: "book", columns: ["authorId"])
        }
    }
    
    enum AuthorCountryIndex: DBMigration {
        static func migrate(db: Database) throws {
            try db.create(index: "author_country", on: "author", columns: ["country"])
        }
    }
    
    enum AuthorUpdateTrigger: DBMigration {
        static func migrate(db: Database) throws {
            try db.execute(sql: """
            CREATE TRIGGER author_update
                AFTER UPDATE ON author
                WHEN NEW.lastUpdate = OLD.lastUpdate
                BEGIN
                    UPDATE place SET lastUpdate = CURRENT_TIMESTAMP WHERE id = NEW.id;
                END
            """)
        }
    }
    
    enum BookUpdateTrigger: DBMigration {
        static func migrate(db: Database) throws {
            try db.execute(sql: """
            CREATE TRIGGER book_update
                AFTER UPDATE ON book
                WHEN NEW.lastUpdate = OLD.lastUpdate
                BEGIN
                    UPDATE place SET lastUpdate = CURRENT_TIMESTAMP WHERE id = NEW.id;
                END
            """)
        }
    }
    
    enum AuthorsPerCountryView: DBMigration {
        static func migrate(db: Database) throws {
            try db.execute(sql: """
            CREATE VIEW authorsPerCountry
                AS
                SELECT country, COUNT(*) as authorsCount
                FROM author
                GROUP BY country
                ORDER BY authorsCount DESC
            """)
        }
    }
    
    enum BooksPerAuthorView: DBMigration {
        static func migrate(db: Database) throws {
            try db.execute(sql: """
            CREATE VIEW booksPerAuthor
                AS
                SELECT author.name, count(book.id) as booksCount
                FROM author
                LEFT JOIN book ON author.id = book.authorId
                GROUP BY author.name
                ORDER BY booksCount DESC
            """)
        }
    }
    
    enum DocumentVirtualTable: DBMigration {
        static func migrate(db: Database) throws {
            try db.create(virtualTable: "document", using: FTS4()) { t in
                t.column("content")
            }
        }
    }
    
    enum Data: DBMigration {
        static func migrate(db: Database) throws {
            try db.execute(sql: """
            INSERT INTO author VALUES (1, 'J.K. Rowling', 'UK', NULL);
            INSERT INTO author VALUES (2, 'J.R.R. Tolkien', 'UK', NULL);
            
            INSERT INTO book VALUES (1, 'Harry Potter and the Philosopher''s Stone', 1, NULL);
            INSERT INTO book VALUES (2, 'Harry Potter and the Chamber of Secrets', 1, NULL);
            INSERT INTO book VALUES (3, 'Harry Potter and the Prisoner of Azkaban', 1, NULL);

            INSERT INTO book VALUES (4, 'The Hobbit', 2, NULL);
            INSERT INTO book VALUES (5, 'The Fellowship of the Ring', 2, NULL);
            """)
        }
    }
}
