import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/course.dart';
import 'package:flutter_ecurie/models/isAdmin.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/adminNavigation_bar.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:flutter_ecurie/services/news_feed.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;

import '../models/event.dart';
import '../providers/nav_non_user.dart';
import '../providers/navigation_bar.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  int login = 0;
  bool _connected = UserManager.isUserConnected;

  void addParticipants() async {
    setState(() {
      widget.event.participants.add(UserManager.user.username);
    });
    var collection = mongodb.getCollection("events");
    await collection.updateOne({
      'title': widget.event.title,
      'photo': widget.event.photo,
      'description': widget.event.description,
      'theme': widget.event.theme,
      'status': widget.event.status
    }, dart.ModifierBuilder().set('participants', widget.event.participants));
  }

  void suppParticipants() async {
    setState(() {
      widget.event.participants.remove(UserManager.user.username);
    });
    var collection = mongodb.getCollection("events");
    await collection.updateOne({
      'title': widget.event.title,
      'photo': widget.event.photo,
      'description': widget.event.description,
      'theme': widget.event.theme,
      'status': widget.event.status
    }, dart.ModifierBuilder().set('participants', widget.event.participants));
  }

  @override
  void initState() {
    print(widget.event.participants);
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text("Soirée : ${widget.event.title}", style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                    )),
                  ),
                  Image(
                      image: NetworkImage(
                          widget.event.photo, scale: 5)),
                  Container(
                    child: Text("Thème de la soirée : ${widget.event.theme}", style: const TextStyle(
                      fontSize: 20.0,
                    )),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text("Description : ${widget.event.description}", style: const TextStyle(
                      fontSize: 20.0,
                    )),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text("Date : ${widget.event.date}", style: const TextStyle(
                      fontSize: 20.0,
                    )),
                  ),
                  Container(
                    child: const Text("Participants", style: TextStyle(
                      fontSize: 20.0,
                    )),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: widget.event.participants.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          child: Card(
                            elevation: 3,
                            child: Center(child: Text(widget.event.participants[index], style: const TextStyle(
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
                            if(widget.event.participants.contains(UserManager.user.username)){
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
                            if(widget.event.participants.contains(
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
