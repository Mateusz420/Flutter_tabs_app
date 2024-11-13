import 'package:flutter/material.dart';
import 'song.dart';
import 'songPage.dart';

class FavoritePage extends StatefulWidget {
  final List<Song> listItems;

  const FavoritePage({super.key, required this.listItems});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<Song> favoriteSongs;

  @override
  void initState() {
    super.initState();
    favoriteSongs = widget.listItems.where((song) => song.favs == 1).toList();
  }

  void songClick(song) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SongPage(
                  songClass: song,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Songs'),
      ),
      body: favoriteSongs.isEmpty
          ? const Center(child: Text('No favorites yet!'))
          : ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];
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
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text(song.favs.toString(),
                            style: const TextStyle(fontSize: 20)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.star),
                        onPressed: () => setState(() {
                          song.favorited();
                        }),
                        color: song.userFav ? Colors.amber : Colors.black,
                      ),
                    ])
                  ],
                ));
              },
            ),
    );
  }
}
