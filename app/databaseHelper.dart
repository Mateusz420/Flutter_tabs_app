import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tabs/song.dart';
import 'dart:async';

Future<void> insertSong(Song song, Future<Database> database) async {
  final db = await database;
  await db.insert(
    'Songs',
    {
      'id': song.id,
      'name': song.name,
      'author': song.author,
      'length': song.length,
      'tabData': song.tabData, // Store JSON data in tabData column
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Song>> songs(database) async {
  final db = await database;
  final Future<List<Map<String, dynamic>>> songsAll = db.query('Songs');

  return [
    for (final {
          'id': id as int,
          'name': name as String,
          'author': author as String,
          'tabData': tabData as String,
          'length': length as double
        } in await songsAll)
      Song(id, name, author, tabData, length)
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
          'length': lenght as double,
          'tabData': tabData as String
        } in await searchedSongs)
      Song(id, name, author, tabData, lenght)
  ];
}

// desnt work cuz the users table is not created for some reason
Future<void> insertUser(user, database) async {
  final db = await database;
  await db.insert('Users', user.toMapUser(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}
