// // entries_service.dart

// import 'dart:async';
// import 'package:intl/intl.dart';

// import 'package:flutter/foundation.dart';
// import 'package:formcapture/filter.dart';
// import 'package:formcapture/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class EntriesService {
//   Database? _db;

//   List<DatabaseEntry> _entries = [];

//   DatabaseUser? _user;

//   static final EntriesService _shared = EntriesService._sharedInstance();
//   EntriesService._sharedInstance() {
//     _entriesStreamController = StreamController<List<DatabaseEntry>>.broadcast(
//       onListen: () {
//         _entriesStreamController.sink.add(_entries);
//       },
//     );
//   }
//   factory EntriesService() => _shared;

//   late final StreamController<List<DatabaseEntry>> _entriesStreamController;

// // filter stream of list of things based on current user
//   Stream<List<DatabaseEntry>> get allEntries =>
//       _entriesStreamController.stream.filter((entry) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return entry.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllEntries();
//         }
//       });

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheEntries() async {
//     final allEntries = await getAllEntries();
//     _entries = allEntries.toList();
//     _entriesStreamController.add(_entries);
//   }

//   Future<DatabaseEntry> updateEntry({
//     required DatabaseEntry entry,
//     required String title,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();
//     // make sure entry exists
//     await getEntry(id: entry.id);

//     final currentTime = DateTime.now();
//     const gmtOffset = Duration(hours: 8); // GMT+08:00
//     final gmtTime = currentTime.add(gmtOffset);

//     // update DB
//     final updatesCount = await db.update(
//       entryTable,
//       {
//         titleColumn: title,
//         textColumn: text,
//         isSyncedWithCloudColumn: 0,
//         modifiedDateColumn: DateFormat('yyyy-MM-dd HH:mm:ss').format(gmtTime)
//       },
//       where: 'id = ?',
//       whereArgs: [entry.id],
//     );

//     if (updatesCount == 0) {
//       throw CouldNotUpdateEntry();
//     } else {
//       final updatedEntry = await getEntry(id: entry.id);
//       _entries.removeWhere((entry) => entry.id == updatedEntry.id);
//       _entries.add(updatedEntry);
//       _entriesStreamController.add(_entries);

//       return updatedEntry;
//     }
//   }

//   Future<Iterable<DatabaseEntry>> getAllEntries() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final entries = await db.query(entryTable);

//     return entries.map((entryRow) => DatabaseEntry.fromRow(entryRow));
//   }

//   Future<DatabaseEntry> getEntry({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final entries = await db.query(
//       entryTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (entries.isEmpty) {
//       throw CouldNotFindEntry();
//     } else {
//       final entry = DatabaseEntry.fromRow(entries.first);
//       _entries.removeWhere((entry) => entry.id == id);
//       _entries.add(entry);
//       _entriesStreamController.add(_entries);
//       return entry;
//     }
//   }

//   Future<int> deleteAllEntries() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = await db.delete(entryTable);
//     _entries = [];
//     _entriesStreamController.add(_entries);
//     return numberOfDeletions;
//   }

//   Future<void> deleteEntry({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       entryTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteEntry();
//     } else {
//       _entries.removeWhere((entry) => entry.id == id);
//       _entriesStreamController.add(_entries);
//     }
//     log("delete entries");
//     printEntryTable();
//   }

//   Future<DatabaseEntry> createEntry({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     // make sure owner exists in the database with the correct id
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }

//     const title = '';
//     const text = '';
//     // create the entry

//     final currentTime = DateTime.now();
//     final gmtOffset = Duration(hours: 8); // GMT+08:00
//     final gmtTime = currentTime.add(gmtOffset);

//     final entryId = await db.insert(entryTable, {
//       userIdColumn: owner.id,
//       titleColumn: title,
//       textColumn: text,
//       createdDateColumn: DateFormat('yyyy-MM-dd HH:mm:ss').format(gmtTime),
//       modifiedDateColumn: DateFormat('yyyy-MM-dd HH:mm:ss').format(gmtTime),
//       isSyncedWithCloudColumn: 1,
//     });

//     final entry = DatabaseEntry(
//       id: entryId,
//       userId: owner.id,
//       title: title,
//       text: text,
//       createdDate: gmtTime,
//       modifiedDate: gmtTime,
//       isSyncedWithCloud: true,
//     );

//     // final entryId = await db.insert(entryTable, {
//     //   userIdColumn: owner.id,
//     //   titleColumn: title,
//     //   textColumn: text,
//     //   createdDateColumn: DateTime.now().toString(),
//     //   modifiedDateColumn: DateTime.now().toString(),
//     //   isSyncedWithCloudColumn: 1,
//     // });

//     // final entry = DatabaseEntry(
//     //   id: entryId,
//     //   userId: owner.id,
//     //   title: title,
//     //   text: text,
//     //   createdDate: DateTime.now(),
//     //   modifiedDate: DateTime.now(),
//     //   isSyncedWithCloud: true,
//     // );

//     _entries.add(entry);
//     _entriesStreamController.add(_entries);

//     printEntryTable();

//     return entry;
//   }

//   Future<void> printEntryTable() async {
//     // Ensure the database is open
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     final List<Map<String, dynamic>> rowsUser = await db.query(userTable);
//     for (var row in rowsUser) {
//       log(row.toString());
//     }

//     // Retrieve all rows from the entry table
//     final List<Map<String, dynamic>> rowsEntry = await db.query(entryTable);
//     // Print each row
//     for (var row in rowsEntry) {
//       log(row.toString());
//     }
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       // empty
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       // create the user table
//       await db.execute(createUserTable);
//       // create entry table
//       await db.execute(createEntryTable);

//       await printEntryTable();

//       await _cacheEntries();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseEntry {
//   final int id;
//   final int userId;
//   final String title;
//   final String text;
//   final DateTime createdDate;
//   final DateTime modifiedDate;
//   final bool isSyncedWithCloud;

//   DatabaseEntry({
//     required this.id,
//     required this.userId,
//     required this.title,
//     required this.text,
//     required this.createdDate,
//     required this.modifiedDate,
//     required this.isSyncedWithCloud,
//   });

//   DatabaseEntry.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         title = map[titleColumn] as String,
//         text = map[textColumn] as String,
//         createdDate = DateTime.parse((map[createdDateColumn]) as String),
//         modifiedDate = DateTime.parse((map[modifiedDateColumn]) as String),
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Entry, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, title = $title, text = $text, createdDate = $createdDate, modifiedDate = $modifiedDate';

//   @override
//   bool operator ==(covariant DatabaseEntry other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'entries.db';
// const entryTable = 'entry';
// const userTable = 'user';
// const idColumn = 'id';
// const emailColumn = 'email';

// const userIdColumn = 'user_id';
// const titleColumn = 'title';
// const textColumn = 'text';
// const createdDateColumn = 'created_date';
// const modifiedDateColumn = 'modified_date';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';

// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//         "id"	INTEGER NOT NULL,
//         "email"	TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );
//       INSERT INTO user 
//       ("email") VALUES ("ziqing0914@gmail.com")''';

// const createEntryTable = '''
// CREATE TABLE IF NOT EXISTS "entry" (
//         "id" INTEGER NOT NULL,
//         "user_id" INTEGER NOT NULL,
//         "title"	TEXT,
//         "text" TEXT,
//         "created_date" TEXT,
//         "modified_date" TEXT,
//         "is_synced_with_cloud" INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';

// //DROP TABLE IF EXISTS "entry";
