import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/isAdmin.dart';
import 'package:flutter_ecurie/models/user.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/nav_non_user.dart';
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

class CavaliersSceen extends StatefulWidget {
  const CavaliersSceen({super.key});

  @override
  State<CavaliersSceen> createState() => _CavaliersSceenState();
}

class _CavaliersSceenState extends State<CavaliersSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste Des Cavaliers"),
      ),
      body: const UserList(),
      // Nav for admin user or not
      bottomNavigationBar:
          IsAdmin.admin == 0 && UserManager.isUserConnected == true
              ? const MyNavigationBar()
              : IsAdmin.admin == 0 && UserManager.isUserConnected == false
                  ? const NavNonUser()
                  : const AdminNavigationBar(),
    );
  }
}
