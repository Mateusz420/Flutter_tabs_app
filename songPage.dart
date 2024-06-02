import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'song.dart';

class SongPage extends StatefulWidget {
  final Song song;

  SongPage(this.song);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  void infoClick(BuildContext context, Song song) {
    setState(() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                          child:
                              Text("Name: ", style: TextStyle(fontSize: 20))),
                      Expanded(
                          child: Text(widget.song.name,
                              style: TextStyle(fontSize: 20))),
                    ]),
                    Row(children: [
                      Expanded(
                          child:
                              Text("Author: ", style: TextStyle(fontSize: 20))),
                      Expanded(
                          child: Text(widget.song.author,
                              style: TextStyle(fontSize: 20))),
                    ]),
                    Row(children: [
                      Expanded(
                          child:
                              Text("Lenght: ", style: TextStyle(fontSize: 20))),
                      Expanded(
                          child: Text(widget.song.lenght.toString(),
                              style: TextStyle(fontSize: 20))),
                    ]),
                  ],
                ));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.name),
        actions: [
          IconButton(
              onPressed: () => infoClick(context, widget.song),
              icon: Icon(Icons.info_outline)),
        ],
      ),
      body: Text("Placehoolder"),
    );
  }
}
