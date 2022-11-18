import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/course.dart';
import 'package:flutter_ecurie/models/isAdmin.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/adminNavigation_bar.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:flutter_ecurie/services/news_feed.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;

import '../providers/nav_non_user.dart';
import '../providers/navigation_bar.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({Key? key, required this.course}) : super(key: key);

  final Course course;

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  int login = 0;
  bool _connected = UserManager.isUserConnected;

  late Course oldCourse;

  void addParticipants() async {
    setState(() {
      widget.course.participants.add(UserManager.user.username);
    });
    var collection = mongodb.getCollection("courses");
    await collection.updateOne({
      'title': widget.course.title,
      'description': widget.course.description,
      'discipline': widget.course.discipline,
      'place' : widget.course.place
    }, dart.ModifierBuilder().set('participants', widget.course.participants));
  }

  void suppParticipants() async {
    setState(() {
      widget.course.participants.remove(UserManager.user.username);
    });
    var collection = mongodb.getCollection("courses");
    await collection.updateOne({
      'title': widget.course.title,
      'description': widget.course.description,
      'discipline': widget.course.discipline,
      'place' : widget.course.place
    }, dart.ModifierBuilder().set('participants', widget.course.participants));
  }

  @override
  void initState() {
    print(widget.course.participants);
    super.initState();
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
              onPressed: () => (Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                  const MyProfile(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              )),
              icon: const Icon(Icons.person),
              label: const Text("profile"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
          else
            ElevatedButton.icon(
              onPressed: () => (Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AuthScreen()))
                  .then((response) => setState(() => {
                // If user is connected to see his profile
                if (response == true)
                  {_connected = true}
                else
                  {_connected = false}
              }))),
              icon: const Icon(Icons.login),
              label: const Text("Se connecter"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
        ],
      ),
      body: Center(
        child: Container(
          width: 1000,
          margin: EdgeInsets.all(16.0),
          child: Card(
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: Text("Cours : ${widget.course.title}", style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold
                  )),
                ),
                Container(
                  child: Text("Discipline du cours : ${widget.course.discipline}", style: const TextStyle(
                      fontSize: 20.0,
                  )),
                ),
                Flexible(
                  flex: 2,
                  child: Text("Description : ${widget.course.description}", style: const TextStyle(
                    fontSize: 20.0,
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Date : ${widget.course.date}", style: const TextStyle(
                  fontSize: 20.0,
                )),
                    Text("Date : ${widget.course.duration}", style: const TextStyle(
                      fontSize: 20.0,
                    )),
                  ],
                ),
                Container(
                  child: const Text("Participants", style: TextStyle(
                    fontSize: 20.0,
                  )),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.course.participants.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        child: Card(
                          elevation: 3,
                          child: Center(child: Text(widget.course.participants[index], style: const TextStyle(
                            fontSize: 20.0,
                          ))),
                        )

                        ,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: ()=>
                        {
                          if(widget.course.participants.contains(UserManager.user.username)){
                            suppParticipants()
                          }else{
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("Vous n'êtes pas inscrit"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            )
                          }
                        },
                        child: Text("Ne pas participer")),
                    ElevatedButton(
                        onPressed: ()=>
                        {
                          if(widget.course.participants.contains(
                              UserManager.user.username)){
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text('Vous êtes deja inscrit'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                            )
                          }else{
                            addParticipants()
                          }
                        },
                        child: Text("Participer"))
                  ],
                )

              ],
            ),
          ),
        )
      ),
      bottomNavigationBar: IsAdmin.admin == 0 && UserManager.isUserConnected == true ? const MyNavigationBar() : IsAdmin.admin == 0 && UserManager.isUserConnected == false ? const NavNonUser() : const AdminNavigationBar(),

    );
  }
}
