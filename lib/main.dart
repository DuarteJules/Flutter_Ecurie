import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ecurie/screens/home_page.dart';
import 'package:flutter_ecurie/screens/horse.dart';

import 'providers/mongodb.dart';

var mongodb = DBConnection.getInstance();
void main() async {
  // LOAD DOTENV 
  await dotenv.load(fileName: ".env");
  // CONNECT MONGO 
  await mongodb.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      debugShowCheckedModeBanner: false,
      routes:
      {HorseList.tag: (context) => const HorseList(),
      },
      home: const MyHomePage(),
    );
  }
}

