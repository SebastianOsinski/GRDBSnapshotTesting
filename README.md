# GRDBSnapshotTesting

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-ED523F.svg)](https://swift.org/download/)
[![Pod version](https://img.shields.io/cocoapods/v/GRDBSnapshotTesting)](https://img.shields.io/cocoapods/v/GRDBSnapshotTesting)
[![License](https://img.shields.io/cocoapods/l/GRDBSnapshotTesting)](https://img.shields.io/cocoapods/l/GRDBSnapshotTesting)

[SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) plug-in for testing [GRDB](https://github.com/groue/GRDB.swift) database migrations.

It allows you to easily test if your database schema and data are migrated correctly.

## Features

GRDBSnapshotTesting creates snapshot files 
which represent your database schema and data.

Snapshot files contain:
- table definitions
- index definitions (if any exists)
- trigger definitions (if any exists)
- view definitions (if any exists)
- all data from all tables

Example snapshot file:

```
======== TABLES ========
CREATE TABLE grdb_migrations (
  identifier TEXT NOT NULL PRIMARY KEY
)

CREATE TABLE "author" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT
  "name" TEXT NOT NULL
  "country" TEXT NOT NULL
  "lastUpdate" DATETIME
)

CREATE TABLE sqlite_sequence(
  name
  seq
)

CREATE TABLE "book" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT
  "title" TEXT NOT NULL
  "authorId" INTEGER NOT NULL REFERENCES "author"("id") ON DELETE CASCADE
  "lastUpdate" DATETIME
)

======== DATA ========

## grdb_migrations
("AuthorTable")
("BookTable")
("Data")

## author
(1, "J.K. Rowling", "UK", NULL)
(2, "J.R.R. Tolkien", "UK", NULL)

## sqlite_sequence
("author", 2)
("book", 5)

## book
(1, "Harry Potter and the Philosopher\'s Stone", 1, NULL)
(2, "Harry Potter and the Chamber of Secrets", 1, NULL)
(3, "Harry Potter and the Prisoner of Azkaban", 1, NULL)
(4, "The Hobbit", 2, NULL)
(5, "The Fellowship of the Ring", 2, NULL)
```

## Usage

```swift
import XCTest
import SnapshotTesting
import GRDB
import GRDBSnapshotTesting

class DatabaseMigrationTests: XCTestCase {
  func testInitialMigration() throws {
    let db = DatabaseQueue()
    
    var migrator = DatabaseMigrator()
    migrator.registerMigration("v1", migrate: Migrations.firstMigration)
  
    try migrator.migrate(db)
    
    assertSnapshot(matching: db, as: .dbDump)
  }
}
```

On first run, above test will create reference snapshot 
file with your database schema and contents. 

On subsequent runs it will check if just created 
snapshot matches prerecorded reference.

`GRDBSnapshotTesting` also contains some extensions for `GRDB` which
allow testing your migrations on prerecorded database files 
without overwriting them:

```swift
class DatabaseMigrationTests: XCTestCase {
  func testSecondMigration() throws {
    // V1DatabaseWithData.sqlite is added to the testing target
    let path = Bundle(for: Self.self).path(forResource: "V1DatabaseWithData", ofType: "sqlite")!

    let db = DatabaseQueue.inMemoryDatabase(fromPath: path)
    
    var migrator = DatabaseMigrator()
    migrator.registerMigration("v2", migrate: Migrations.secondMigration)
  
    try migrator.migrate(db)
    
    assertSnapshot(matching: db, as: .dbDump)
  }
}
```

`DatabaseQueue.inMemoryDatabase(fromPath:)` creates in-memory database
with the same schema and data as the database file at given path.

That way you can create multiple database files with edge-case data 
and test your migrations thoroughly.

## Installation

#### CocoaPods

Add the pod to your testing target in `Podfile`:

```ruby
target 'MyAppTests' do
  pod 'GRDBSnapshotTesting', '~> 0.1'
end
```

#### Swift Package Manager

Add the package to your testing target in `Package.swift`:

```diff
 let package = Package(
     dependencies: [
+        .package(url: "https://github.com/SebastianOsinski/GRDBSnapshotTesting.git", ...)
     ],
     targets: [
         .testTarget(
             dependencies: [
+                "GRDBSnapshotTesting"
             ])
     ]
 )
```
