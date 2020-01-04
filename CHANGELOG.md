## 1.0.0

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