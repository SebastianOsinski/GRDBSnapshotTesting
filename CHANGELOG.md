## 0.3.0

- Compatibility with GRDB 5
- Minimal iOS target bumped to iOS 11

## 0.2.1

- Fixed issues which caused linking error on Xcode 11.4 when installed with CocoaPods

## 0.2.0

**New**

- SPM support by [groue](https://github.com/groue)

**Fixed**

- Snapshotting database which contains table with SQLite keyword as a name works correctly now

**Breaking changes**

- Snapshots no longer contain SQLite and GRDB internal tables
- Snapshots of empty database have placeholders for tables and data
- All objects (tables, indexes etc.) are ordered by their name
- Dumped rows are now explicitly ordered by table's primary key

## 0.1.0

Initial release