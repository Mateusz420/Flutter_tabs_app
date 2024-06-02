mport 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'homePage.dart';
import 'databaseHelper.dart';
import 'song.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Song song = Song(0, "Master of Puppets", "Metallica", 8.35);
  final database = openDatabase(join(await getDatabasesPath(), 'Tabs.db'),
      version: 1, onCreate: ((db, version) async {
    await db.execute(
        'CREATE TABLE Songs (id INTEGER PRIMARY KEY, name STRING, author STRING, lenght DOUBLE)');
    await db.execute(
        'CREATE TABLE Users (id INTEGER PRIMARY KEY AUTOINCREMENT, username STRING, password STRING)');
  }));
  insertSong(song, database);
  List<Song> allSongs = await songs(database);
  runApp(MyApp(allSongs, await database));
}

class MyApp extends StatelessWidget {
  final List<Song> allSongs;
  final Database database;

  const MyApp(this.allSongs, this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tabs",
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(allSongs, database),
    );
  }
}
