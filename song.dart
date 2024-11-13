class Song {
  int id;
  String name;
  String author;
  double length = 0;
  int favs = 0;
  bool userFav = false;
  String tabData;

  Song(this.id, this.name, this.author, this.tabData, [this.length = 0]);

  @override
  String toString() {
    return 'Song{id: $id, name: $name, author: $author, length: $length}';
  }

  Map<String, dynamic> toMapSong() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'length': length,
      'tabData': tabData,
    };
  }

  void favorited() {
    userFav = !userFav;

    if (userFav) {
      favs += 1;
    } else {
      favs -= 1;
    }
  }
}
