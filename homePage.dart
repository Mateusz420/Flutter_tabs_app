import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'songList.dart';
import 'textInputWidget.dart';
import 'song.dart';
import 'loginPage.dart';
import 'databaseHelper.dart';

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

  void newSong(text) {
    setState(() {
      widget.allSongs.add(Song(widget.id, text, widget.name));
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tabs"),
        actions: [
          IconButton(
              //This has to be changed, make this button show the search box in the future
              onPressed: () => setState(() {
                    TextInputWidget(songSearchUpdate, widget.database);
                  }),
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () => loginClick(),
            icon: Icon(Icons.person),
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
