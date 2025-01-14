import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'homePage.dart';
import 'databaseHelper.dart';
import 'package:tabs/song.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await deleteDatabase(join(await getDatabasesPath(), 'Tabs.db'));

  Song MasterOfPuppets = Song(0, "Master of Puppets", "Metallica",
      "assets/master_of_puppets.json", 8.35);
  Song SmellsLikeTeenSpirit = Song(1, "Smells Like Teen Spirit", "Nirvana",
      "assets/smells_like_teen_spirit.json", 5.02);
  Song TheTrooper =
      Song(2, "The Trooper", "Iron Maiden", "assets/the_trooper.json", 4.13);

  final database = openDatabase(join(await getDatabasesPath(), 'Tabs.db'),
      version: 1, onCreate: ((db, version) async {
    await db.execute(
        'CREATE TABLE Songs (id INTEGER PRIMARY KEY, name STRING, author STRING, length DOUBLE, tabData STRING)');
    await db.execute(
        'CREATE TABLE Users (id INTEGER PRIMARY KEY AUTOINCREMENT, username STRING, password STRING)');
  }));

  insertSong(MasterOfPuppets, database);
  insertSong(SmellsLikeTeenSpirit, database);
  insertSong(TheTrooper, database);
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
