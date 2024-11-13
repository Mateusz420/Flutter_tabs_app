import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'homePage.dart';
import 'song.dart';
import 'registerPage.dart';

class LoginPage extends StatelessWidget {
  final List<Song> allSongs;
  final Database database;

  const LoginPage(this.allSongs, this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Body(allSongs, database),
    );
  }
}

class Body extends StatefulWidget {
  final List<Song> allSongs;
  final Database database;

  const Body(this.allSongs, this.database, {super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String name = "";
  String password = "";
  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();

  void clickLogin(name, password) {
    setState(() {
      this.name = controller_username.text;
      this.password = controller_password.text;
      FocusScope.of(context).unfocus();
      controller_username.clear();
      controller_password.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(widget.allSongs, widget.database, name: this.name)));
    });
  }

  void registerButtonClick() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                RegisterPage(widget.allSongs, widget.database))));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  controller: controller_username,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Username:",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black)),
                  ))),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller_password,
                decoration: InputDecoration(
                    icon: const Icon(Icons.password),
                    labelText: "Password",
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(width: 5, color: Colors.black)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.done),
                      onPressed: () => clickLogin(name, password),
                    )),
                obscureText: true,
                obscuringCharacter: "*",
              )),
          Container(
            width: 250,
            height: 50,
            color: Colors.amber,
            child: ListTile(
              title: const Text(
                "Register",
                textAlign: TextAlign.center,
              ),
              onTap: () => registerButtonClick(),
            ),
          ),
        ]));
  }
}
