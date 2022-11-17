import 'package:flutter/material.dart';
import 'package:flutter_ecurie/screens/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ecurie/screens/horse.dart';
import '../screens/cavaliers_screen.dart';
import '../screens/course_screen.dart';
import '../screens/validate_courses_screen.dart';

int _selectedIndex = 2;
class AdminNavigationBar extends StatefulWidget {
  const AdminNavigationBar({ Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<AdminNavigationBar> {
  

  void _onItemTapped(int index) {
    // Prevent user from reloading if he is on the same page
    if (index == _selectedIndex) {
      return;
    }
    
    setState(() {
      _selectedIndex = index;
       switch(_selectedIndex){
      case 0:
         case 0:
           Navigator.pushReplacement(
             context,
             PageRouteBuilder(
               pageBuilder: (context, animation1, animation2) => HorseList(),
               transitionDuration: Duration.zero,
               reverseTransitionDuration: Duration.zero,
             ),
           );
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
      case 2:
      Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const MyHomePage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
        break;
      case 5:
      Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const ValidateCourses(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
        break;
        case 6:
      Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const CavaliersSceen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
        break;
      
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.horse),
            label: 'Chevaux',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Cours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.champagneGlasses),
            label: 'Evênements',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.trophy),
            label: 'Concours',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_sharp),
            label: 'Demandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'Cavaliers',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 20),
      );
  }
}