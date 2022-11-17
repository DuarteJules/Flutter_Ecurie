import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/course_screen.dart';
import 'package:flutter_ecurie/widgets/horses_list.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ecurie/screens/horse.dart';

import '../providers/mongodb.dart';

import '../providers/navigation_bar.dart';
import '../widgets/news_list.dart';
import '../widgets/user_list.dart';

var mongodb = DBConnection.getInstance();
bool _connected = false;
class MyHomePage extends StatefulWidget {
  static const tag = "Home page";
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  
  int login = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
       switch(_selectedIndex){
      case 0:
        // Navigator.pushNamed(context, "/first");
        break;
      case 1:
        Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const CourseScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
        break;
    }
    });
  }

  @override
  void initState () {
    super.initState();
    setState(() {
      const UserList();
      });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text("My little pony"),
        centerTitle: false,
        actions: [
          if (_connected)
            ElevatedButton.icon(
              onPressed: ()=>(
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const MyProfile(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  )
              ),
              icon: const Icon(Icons.person),
              label: const Text("profile"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
          else
            ElevatedButton.icon(
              onPressed: () => {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()))
                    .then((response) => setState(() => {
                          // If user is connected to see his profile
                          if (response == true)
                            {_connected = true}
                          else
                            {_connected = false}
                        })),
              },
              icon: const Icon(Icons.login),
              label: const Text("Se connecter"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
        ],
      ),
      // This return list delocalised into USERLIST
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                login = 0;
              });
            },
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: const Text('Flux'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                login = 1;
              });
            },
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: const Text('Semaines à venir'),
          ),
          Expanded(
            child: login == 0 ? const NewsCardList() : const HosrsesList(),
          )
        ],
      )),
      bottomNavigationBar: const MyNavigationBar(),
    );
  }
}