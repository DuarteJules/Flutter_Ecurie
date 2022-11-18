import 'package:flutter/material.dart';
import 'package:flutter_ecurie/screens/contest_screen.dart';
import 'package:flutter_ecurie/screens/event_screen.dart';
import 'package:flutter_ecurie/screens/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ecurie/screens/horse.dart';
import '../models/user_manager.dart';
import '../screens/course_screen.dart';

int _selectedIndex = 2;

class NavNonUser extends StatefulWidget {
  const NavNonUser({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavNonUser> {
  late final bool isConnected;
  
  void _onTappedHome(int index) {
    if (index == _selectedIndex) {
      return;
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const MyHomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.black12,
        height: 85,
        child: InkWell(
            onTap: () => _onTappedHome(2),
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: Colors.amber[800],
                  ),
                  Text('Home'),
                ],
              ),
            )));
  }
}
