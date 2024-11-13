import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'song.dart';

class TextInputWidget extends StatefulWidget {
  final Function(String) callback;
  final Database database;

  const TextInputWidget(this.callback, this.database, {super.key});

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();
  List<Song> searchedSongs = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: "Search",
            suffixIcon: IconButton(
              icon: const Icon(Icons.check_circle_outline),
              splashColor: Colors.blue,
              tooltip: "Confirm",
              onPressed: () => widget.callback(controller.text),
            )));
  }
}
