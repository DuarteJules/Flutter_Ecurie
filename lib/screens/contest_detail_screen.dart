import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/course.dart';
import 'package:flutter_ecurie/models/isAdmin.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/adminNavigation_bar.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:flutter_ecurie/services/news_feed.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;

import '../models/contest.dart';
import '../providers/nav_non_user.dart';
import '../providers/navigation_bar.dart';

class ContestDetails extends StatefulWidget {
  const ContestDetails({Key? key, required this.contest}) : super(key: key);

  final Contest contest;

  @override
  _ContestDetailsState createState() => _ContestDetailsState();
}

const List<String> list = <String>[
  'Amateur',
  "Club1",
  'Club2',
  'Club3',
  'Club4'
];

class _ContestDetailsState extends State<ContestDetails> {
  int login = 0;
  bool _connected = UserManager.isUserConnected;
  late String dropdownValue = list.first;

  late Contest oldContest;

  void addParticipants() async {
    setState(() {
      widget.contest.participants.add({
        "name" : UserManager.user.username,
        "category" : dropdownValue
      });
    });
    var collection = mongodb.getCollection("contest");
    await collection.updateOne({
      'title': widget.contest.title,
      'description': widget.contest.description,
      'photo': widget.contest.photo,
      'adress' : widget.contest.adress,
      'status': widget.contest.status
    }, dart.ModifierBuilder().set('participants', widget.contest.participants));
  }
  late var index;
  void suppParticipants() async {
    setState(() {
      widget.contest.participants.forEach((element) {
        if(element["name"] == UserManager.user.username){
          index = widget.contest.participants.indexWhere((participant) => participant["name"] == element["name"]);
        }
      });
      widget.contest.participants.removeAt(index);

    });
    var collection = mongodb.getCollection("contest");
    await collection.updateOne({
      'title': widget.contest.title,
      'description': widget.contest.description,
      'photo': widget.contest.photo,
      'adress' : widget.contest.adress,
      'status': widget.contest.status
    }, dart.ModifierBuilder().set('participants', widget.contest.participants));
  }

  @override
  void initState() {
    print(widget.contest.participants);
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
                    child: Text("Concours : ${widget.contest.title}", style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                    )),
                  ),
                  Image(
                      image: NetworkImage(
                          widget.contest.photo, scale: 5)),
                  Container(
                    child: Text("Lieu : ${widget.contest.adress}", style: const TextStyle(
                      fontSize: 20.0,
                    )),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text("Description : ${widget.contest.description}", style: const TextStyle(
                      fontSize: 20.0,
                    )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Date : ${widget.contest.date}", style: const TextStyle(
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
                      itemCount: widget.contest.participants.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          child: Card(
                            elevation: 3,
                            child: Center(child: Text("Nom : ${widget.contest.participants[index]["name"]} | Catégorie : ${widget.contest.participants[index]["category"]}", style: const TextStyle(
                              fontSize: 20.0,
                            ))),
                          )
                          ,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: DropdownButtonFormField<String>(
                      value: dropdownValue,
                      elevation: 16,
                      decoration: const InputDecoration(
                          labelText: "Choisissez une catégorie" //label text of field
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: ()=>
                          {
                          widget.contest.participants.forEach((element) {
                            if(element["name"] == UserManager.user.username){
                              suppParticipants();
                            }
                            else{
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
                              );
                          }
                          })
                          },
                          child: Text("Ne pas participer")),
                      ElevatedButton(
                          onPressed: ()=>
                          {
                            if(widget.contest.participants.contains(
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
