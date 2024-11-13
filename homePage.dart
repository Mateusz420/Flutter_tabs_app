import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tabs/favoritePage.dart';
import 'songList.dart';
import 'textInputWidget.dart';
import 'song.dart';
import 'loginPage.dart';
import 'databaseHelper.dart';
import 'tunerPage.dart';

class HomePage extends StatefulWidget {
  final String name;
  final int id;
  final List<Song> allSongs;
  final Database database;

  const HomePage(this.allSongs, this.database,
      {this.id = 0, this.name = "Guest", super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Song> searchedSongs;

  @override
  void initState() {
    super.initState();
    searchedSongs = List.from(widget.allSongs);
  }

  void songSearchUpdate(searchWord) async {
    if (searchWord == "") {
      searchedSongs = await songs(widget.database);
    } else {
      searchedSongs = await songSearch(widget.database, searchWord);
    }
    setState(() {
      HomePage(searchedSongs, widget.database);
    });
    FocusScope.of(context).unfocus();
  }

  void loginClick() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(widget.allSongs, widget.database)));
  }

  void tunerClick() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const tunerPage()));
  }

  void favClick() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FavoritePage(listItems: widget.allSongs)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tabs"),
        actions: [
          IconButton(
              onPressed: () => setState(() {
                    tunerClick();
                  }),
              icon: const Icon(Icons.music_note_rounded)),
          IconButton(
            onPressed: () => favClick(),
            icon: const Icon(Icons.star),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () => loginClick(),
            icon: const Icon(Icons.person),
            iconSize: 30,
          ),
        ],
      ),
      body: Column(children: <Widget>[
        TextInputWidget(songSearchUpdate, widget.database),
        Expanded(child: SongList(searchedSongs)),
      ]),
    );
  }
}
