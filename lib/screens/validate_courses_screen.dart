import 'package:flutter/material.dart';
import 'package:flutter_ecurie/widgets/asked_courses_list.dart';

import '../models/isAdmin.dart';
import '../models/user_manager.dart';
import '../providers/adminNavigation_bar.dart';
import '../providers/nav_non_user.dart';
import '../providers/navigation_bar.dart';

class ValidateCourses extends StatefulWidget {
  const ValidateCourses({Key? key}) : super(key: key);

  @override
  _ValidateCoursesState createState() => _ValidateCoursesState();
}

class _ValidateCoursesState extends State<ValidateCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demandes de cours"),
      ),
      body: const AskedCoursesList(),
      bottomNavigationBar:
          IsAdmin.admin == 0 && UserManager.isUserConnected == true
              ? const MyNavigationBar()
              : IsAdmin.admin == 0 && UserManager.isUserConnected == false
                  ? const NavNonUser()
                  : const AdminNavigationBar(),
    );
  }
}
