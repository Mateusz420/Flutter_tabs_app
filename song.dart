class Song {
  int id;
  String name;
  String author;
  double lenght = 0;
  int favs = 0;
  bool userFav = false;

  Song(this.id, this.name, this.author, [this.lenght = 0]);

  @override
  String toString() {
    return 'Song{id: $id, name: $name, author: $author, lenght: $lenght}';
  }

  Map<String, dynamic> toMapSong() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'lenght': lenght,
    };
  }

  void favorited() {
    userFav = !userFav;

    if (userFav) {
      this.favs += 1;
    } else {
      this.favs -= 1;
    }
  }
}
