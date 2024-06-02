import 'package:flutter/material.dart';
import 'song.dart';
import 'songPage.dart';

class SongList extends StatefulWidget {
  final List<Song> listItems;

  const SongList(this.listItems, {super.key});

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  void songClick(song) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SongPage(song)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listItems.length,
      itemBuilder: (context, index) {
        var song = widget.listItems[index];

        return Card(
            child: Row(
          children: [
            Expanded(
                child: ListTile(
              title: Text(song.name),
              subtitle: Text(song.author),
              onTap: () => songClick(song),
            )),
            Row(children: [
              Container(
                child:
                    Text(song.favs.toString(), style: TextStyle(fontSize: 20)),
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              ),
              IconButton(
                icon: Icon(Icons.star),
                onPressed: () => setState(() {
                  song.favorited();
                }),
                color: song.userFav ? Colors.amber : Colors.black,
                // "?" <- if true ":" <- else
              ),
            ])
          ],
        ));
      },
    );
  }
}
