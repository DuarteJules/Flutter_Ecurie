import 'package:flutter/material.dart';

import '../providers/navigation_bar.dart';
import '../widgets/login_form.dart';
import '../widgets/signup_form.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  int login = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
          child: Column(children: [
        ElevatedButton(
          onPressed: () {
            print("test");
            // setState(() {
            //   login = 0;
            // });
          },
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          child: const Text('Créer un cours'),
        ),
      ])),
      bottomNavigationBar: const MyNavigationBar(),
    );
  }
}
