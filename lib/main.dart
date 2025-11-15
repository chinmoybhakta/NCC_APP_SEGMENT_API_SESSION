import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ncc_project/weather_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: WeatherApp(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  late Map<String, dynamic>? data;

  @override
  void initState() {
    _controller = TextEditingController();
    data = null;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> searchQuery(String query) async {
    final url =
        "https://newsapi.org/v2/everything?q=$query&from=2025-11-14&to=2025-11-14&sortBy=popularity&apiKey=e7b770bd0083481a9a53c169c5310d21";
    try {
      final response = await http.get(Uri.parse(url));
      final body = jsonDecode(response.body);
      setState(() {
        data = (body);
      });

    } catch (e) {
      log("Error in API $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 200),
            TextFormField(
              controller: _controller,
              onFieldSubmitted: (value) async{
                log(value);
                  await searchQuery(value);
              },
            ),
            if (data != null) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: data?["articles"].length ?? 0,
                  itemBuilder: (context, index) {
                    final article = data?["articles"][index];

                    return ListTile(
                      leading: article["urlToImage"] != null
                          ? Image.network(article["urlToImage"], width: 60, fit: BoxFit.cover)
                          : const Icon(Icons.image),
                      title: Text(article["title"] ?? "No Title"),
                      subtitle: Text(article["author"] ?? "Unknown"),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
