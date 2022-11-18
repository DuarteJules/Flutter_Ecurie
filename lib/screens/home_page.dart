import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/isAdmin.dart';
import 'package:flutter_ecurie/models/user.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/course_screen.dart';
import 'package:flutter_ecurie/widgets/horses_list.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ecurie/screens/horse.dart';

import '../providers/adminNavigation_bar.dart';
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
  
  int viewFlux = 0;


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
                            {
                              _connected = true,
                              // See if user is ADMIN
                              if (UserManager.user.role == 2)
                                {
                                  IsAdmin.admin = 1,
                                }
                            }
                          else
                            {_connected = false,
                            
                            }
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
                viewFlux = 0;
              });
            },
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: const Text('Flux'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                viewFlux = 1;
              });
            },
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: const Text('Semaines à venir'),
          ),
          Expanded(
            child: viewFlux == 0 ? const NewsCardList() : const HosrsesList(),
          )
        ],
      )),
      // Nav for admin user or not
      bottomNavigationBar:  IsAdmin.admin == 0  ? const MyNavigationBar() : const AdminNavigationBar(),
    );
  }
}