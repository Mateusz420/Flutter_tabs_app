import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tabs/song.dart';

class TabPage extends StatefulWidget {
  final Song songClass;

  const TabPage({super.key, required this.songClass});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  List<List<String>> tabLines = [];
  String title = 'Loading...';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchTabData(widget.songClass);
  }

  // Fetch the tab data from the Python backend
  Future<void> fetchTabData(songClass) async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.61:39641/get-tabs'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        var songTab;

        if (jsonResponse['songs'] != null && jsonResponse['songs'] is List) {
          for (int i = 0;
              jsonResponse['songs'][i]['title'] == songClass.title;
              i++) {
            songTab = jsonResponse['songs'][i];
          }

          setState(() {
            title = songTab['title'] ?? 'Untitled';
            tabLines = List<List<String>>.from(
                songTab['tab'].map((line) => List<String>.from(line)));
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Error: No songs available';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error fetching tab data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  // Display the guitar tab as six lines
  Widget buildTabLine(List<String> lines) {
    return Column(
      children: lines
          .map((line) => Text(line,
              style: const TextStyle(fontFamily: 'Courier', fontSize: 16)))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: tabLines.length,
                    itemBuilder: (context, index) {
                      return buildTabLine(tabLines[index]);
                    },
                  ),
                ),
    );
  }
}
