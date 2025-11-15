import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late TextEditingController _latCon;
  late TextEditingController _longCon;
  late Map<String, dynamic>? data;

  @override
  void initState() {
    _latCon = TextEditingController();
    _longCon = TextEditingController();
    data = null;
    super.initState();
  }

  @override
  void dispose() {
    _latCon.dispose();
    _longCon.dispose();
    super.dispose();
  }

  Future<void> searchArea(String lat, String long) async {
    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current=temperature_2m";
    try {
      final response = await http.get(Uri.parse(url));
      final finalResponse = jsonDecode(response.body);
      setState(() {
        data = finalResponse;
      });
    } catch (e) {
      log("Error in API cal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Weather App"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 150, child: TextFormField(controller: _latCon)),
              SizedBox(width: 150, child: TextFormField(controller: _longCon)),
            ],
          ),
          SizedBox(height: 50,),
          ElevatedButton(
            onPressed: () async {
              await searchArea(_latCon.text.trim(), _longCon.text.trim());
            },
            child: Text("Submit"),
          ),
          Text(
            "Temperature: ${data?["current"]["temperature_2m"] ?? "N/A"}",
            style: TextStyle(fontSize: 50),
          ),
        ],
      ),
    );
  }
}
