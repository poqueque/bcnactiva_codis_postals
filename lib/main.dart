import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../styles/app_styles.dart';
import 'models/place.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var zipController = TextEditingController();
  Place? place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: TextField(
                onChanged: (value) {
                  getZipCode(value);
                },
                controller: zipController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Introdueix un codi postal',
                ),
                style: const TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              ),
            ),
            if (place != null)
              Text(
                place!.places.first.placeName,
                style: AppStyles.largeTitle,
              ),
            if (place != null)
              Text(
                place!.places.first.state,
                style: AppStyles.dataLabelStyle,
              ),
            if (place != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.place),
                  SizedBox(width: 8),
                  Text(
                    place!.places.first.longitude,
                    style: AppStyles.subTitle,
                  ),
                  SizedBox(width: 8),
                  Text(
                    place!.places.first.latitude,
                    style: AppStyles.subTitle,
                  ),
                ],
              ),
            if (place == null)
              Text(
                "El codi ${zipController.text} no pertany a cap localitat",
                style: AppStyles.error,
              )
          ],
        ),
      ),
    );
  }

  void getZipCode(String value) async {
    http.Response zipCodeData =
        await http.get(Uri.parse("https://api.zippopotam.us/es/$value"));
    try {
      place = placeFromJson(zipCodeData.body);
    } catch (e) {
      place = null;
    }
    setState(() {});
  }
}
