import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart' as services;

import 'package:tabs/song.dart';

class SongPage extends StatefulWidget {
  final Song songClass;

  const SongPage({super.key, required this.songClass});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  Map<String, List<String>> tabData = {
    'e': [],
    'B': [],
    'G': [],
    'D': [],
    'A': [],
    'E': []
  };
  String errorMessage = '';
  bool isLoading = true;
  bool isPlaying = false;

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    loadTabs();
    setLandscapeMode();
  }

  @override
  void dispose() {
    resetOrientation();
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadTabs() async {
    try {
      final String data = await rootBundle.loadString(widget.songClass.tabData);
      final Map<String, dynamic> song = json.decode(data);

      if (song['tab'] is Map<String, dynamic>) {
        final Map<String, dynamic> tabs = song['tab'];

        setState(() {
          tabData = {
            'e': List<String>.from(tabs['e'] ?? []),
            'B': List<String>.from(tabs['B'] ?? []),
            'G': List<String>.from(tabs['G'] ?? []),
            'D': List<String>.from(tabs['D'] ?? []),
            'A': List<String>.from(tabs['A'] ?? []),
            'E': List<String>.from(tabs['E'] ?? []),
          };
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Tabs not found for "${widget.songClass.name}".';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load tabs: $e';
        isLoading = false;
      });
    }
  }

  void setLandscapeMode() {
    services.SystemChrome.setPreferredOrientations([
      services.DeviceOrientation.landscapeRight,
      services.DeviceOrientation.landscapeLeft,
    ]);
  }

  void resetOrientation() {
    services.SystemChrome.setPreferredOrientations([
      services.DeviceOrientation.portraitUp,
      services.DeviceOrientation.portraitDown,
    ]);
  }

  void startScrolling() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 5, // Adjust scroll speed here
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });
  }

  void stopScrolling() {
    _scrollTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.songClass.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Back"),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Scrollable content
                    Positioned.fill(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTabLine('e'),
                            buildTabLine('B'),
                            buildTabLine('G'),
                            buildTabLine('D'),
                            buildTabLine('A'),
                            buildTabLine('E'),
                          ],
                        ),
                      ),
                    ),
                    // Static arrow indicator at the left of the screen
                    const Positioned(
                      left: 16,
                      top: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.arrow_drop_up,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    // Play/Stop buttons at the bottom
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (!isPlaying) {
                                startScrolling();
                                setState(() {
                                  isPlaying = true;
                                });
                              }
                            },
                            child: const Icon(Icons.play_circle_outlined),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (isPlaying) {
                                stopScrolling();
                                setState(() {
                                  isPlaying = false;
                                });
                              }
                            },
                            child: const Icon(Icons.pause_circle_outline_sharp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget buildTabLine(String string) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tabData[string]!.map((tabPart) {
        return Text(
          '$tabPart  ',
          style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
        );
      }).toList(),
    );
  }
}
