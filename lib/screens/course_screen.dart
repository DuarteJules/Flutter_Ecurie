import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/isAdmin.dart';
import 'package:flutter_ecurie/providers/adminNavigation_bar.dart';

import '../providers/navigation_bar.dart';
import '../widgets/course_form.dart';
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
          onPressed: () => (showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: const Text('Créez votre cours'),
                  content: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 800,
                      child: const CourseForm())))),
          child: const Text('Créer un cours'),
        ),
      ])),
      bottomNavigationBar: IsAdmin.admin == 0 ? const MyNavigationBar() : const AdminNavigationBar(),
    );
  }
}
