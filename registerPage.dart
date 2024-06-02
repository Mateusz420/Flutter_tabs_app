import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tabs/homePage.dart';
import 'databaseHelper.dart';
import 'user.dart';
import 'song.dart';

class RegisterPage extends StatelessWidget {
  final Database database;
  final List<Song> allSongs;
  const RegisterPage(this.allSongs, this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Body(allSongs, database),
    );
  }
}

class Body extends StatefulWidget {
  final Database database;
  final List<Song> allSongs;
  const Body(this.allSongs, this.database, {super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();
  TextEditingController controller_confirm_password = TextEditingController();

  void clickRegister() async {
    User user = User(controller_username.text, controller_password.text);
    insertUser(user, widget.database);

    controller_username.clear();
    controller_password.clear();
    controller_confirm_password.clear();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                HomePage(widget.allSongs, widget.database))));
  }

  bool passwordCheck() {
    if (controller_password.text == controller_confirm_password.text) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: controller_username,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black)),
                    labelText: "Username:"),
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: controller_password,
                decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black)),
                    labelText: "Password:"),
              )),
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: controller_confirm_password,
                decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black)),
                    labelText: "Confirm Password:",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.done),
                      onPressed: passwordCheck()
                          ? () => clickRegister()
                          : () => setState(() {
                                controller_username.clear();
                                controller_password.clear();
                                controller_confirm_password.clear();
                              }),
                    )),
              ))
        ]));
  }
}
