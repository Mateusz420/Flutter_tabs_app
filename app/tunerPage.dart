import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class tunerPage extends StatefulWidget {
  const tunerPage({super.key});

  @override
  State<tunerPage> createState() => _tunerPageState();
}

class _tunerPageState extends State<tunerPage> {
  String predictedSound = '';
  bool running = true;

  Future<void> soundPrediction() async {
    running = true;
    while (running) {
      try {
        var response = await http.post(
          Uri.parse('http://192.168.1.87:39640/start-recording'),
        );

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          setState(() {
            predictedSound = jsonResponse['predicted_sound'];
          });
        } else {
          setState(() {
            predictedSound = 'Error: Unable to predict sound.';
          });
        }
      } catch (e) {
        setState(() {
          predictedSound = 'Error: $e';
        });
      }
    }
  }

  bool stopPrdicting() {
    predictedSound = 'Stopped The Program';
    return running = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sound Prediction"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: soundPrediction,
            child: const Text("Start Tuner"),
          ),
          const SizedBox(height: 20),
          // Display the predicted sound result
          Text(
            predictedSound,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: stopPrdicting,
            child: const Text("Stop Tuner"),
          ),
        ],
      ),
    );
  }
}
