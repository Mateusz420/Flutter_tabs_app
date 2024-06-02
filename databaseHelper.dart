import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'song.dart';
import 'dart:async';

// doesnt work idk why
Future<Database> loadDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;
  final database = openDatabase(join(await getDatabasesPath(), 'Tabs.db'),
      version: 1, onCreate: ((db, version) {
    return db.execute(
        'CREATE TABLE Songs (id INTEGER PRIMARY KEY, name STRING, author STRING, lenght DOUBLE)');
  }));
  return database;
}

Future<void> insertSong(song, database) async {
  final db = await database;
  await db.insert('Songs', song.toMapSong(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Song>> songs(database) async {
  final db = await database;
  final Future<List<Map<String, dynamic>>> songsAll = db.query('Songs');

  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'author': author as String,
          'lenght': lenght as double
        } in await songsAll)
      Song(id, name, author, lenght)
  ];
}

Future<List<Song>> songSearch(database, searchWord) async {
  final db = await database;
  final Future<List<Map<String, dynamic>>> searchedSongs =
      db.query('Songs', where: 'name = ?', whereArgs: [searchWord]);

  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'author': author as String,
          'lenght': lenght as double,
        } in await searchedSongs)
      Song(id, name, author, lenght)
  ];
}

// desnt work cuz the users table is not created for some reason
Future<void> insertUser(user, database) async {
  final db = await database;
  await db.insert('Users', user.toMapUser(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}
