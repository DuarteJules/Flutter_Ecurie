import 'package:flutter_ecurie/models/contest.dart';
import 'package:flutter_ecurie/models/contestCategory.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;
import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/adminNavigation_bar.dart';
import 'package:flutter_ecurie/providers/navigation_bar.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:intl/intl.dart';

import '../models/isAdmin.dart';
import '../providers/mongodb.dart';

var mongodb = DBConnection.getInstance();

class ContestList extends StatefulWidget {
  static const tag = "Event List";

  const ContestList({super.key});

  @override
  State<ContestList> createState() => _ContestListState();
}

const List<String> list = <String>[
  'Amateur',
  "Club1",
  'Club2',
  'Club3',
  'Club4'
];

class _ContestListState extends State<ContestList> {
  bool _connected = UserManager.isUserConnected;
  late String dropdownValue = list.first;

  final _formKey = GlobalKey<FormState>();
  final adressController = TextEditingController();
  final photoController = TextEditingController();
  final dateController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Contest> contests = [];
  List<Contest> displayContests = [];

  bool allEvents = true;

  late Contest oldContest;

  void getEvents() async {
    var collection = mongodb.getCollection("contest");
    var horsesJson = await collection.find().toList();
    Contest contest = Contest("", "", "", "", "",[], false);
    setState(() {
      horsesJson.forEach((element) {
        contests.add(contest.fromJson(element));
      });
    });
    takeAllContest();
  }

  void addContest() async {
    var collection = mongodb.getCollection("contest");
    await collection.insertOne({
      'adress': adressController.text,
      'date': DateTime.parse(dateController.text),
      'photo': photoController.text,
      'description': descriptionController.text,
      'title': titleController.text,
      'status': false,
      'participants': [],
      'createdAt' : DateTime.now()
    });
    setState(() {
      Contest contest = Contest(
        titleController.text,
        descriptionController.text,
        dateController.text,
        adressController.text,
        photoController.text,
        [],
        false,
      );
      contests.add(contest);
      takeAllContest();
    });
    adressController.text = "";
    dateController.text = "";
    photoController.text = "";
    descriptionController.text = "";
    titleController.text = "";
  }

  void addParticipants() async {
    oldContest.participants.add({
      "name" : UserManager.user.username,
      "category" : dropdownValue
    });
    var collection = mongodb.getCollection("contest");
    await collection.updateOne({
      'title': oldContest.title,
      'photo': oldContest.photo,
      'description': oldContest.description,
      'adress': oldContest.adress,
      'status': oldContest.status
    }, dart.ModifierBuilder().set('participants', oldContest.participants));
    setState(() {
      int index = contests.indexWhere((element) =>
      element.title == oldContest.title &&
          element.photo == oldContest.photo &&
          element.date == oldContest.date &&
          element.description == oldContest.description &&
          element.adress == oldContest.adress &&
          element.participants == oldContest.participants &&
          element.status == oldContest.status);
      contests[index] = oldContest;
    });
    takeAllContest();
  }

  void takeAllContest() {
    setState(() {
      displayContests.clear();
      displayContests.addAll(contests);
      allEvents = true;
    });
  }

  void takeMyContest() {
    setState(() {
      displayContests.clear();
      contests.forEach((element) {
        element.participants.forEach((participant) {
          if (participant["name"] == UserManager.user.username){
            displayContests.add(element);
          }
        });
      });
      allEvents = false;
    });
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text("My little pony"),
        centerTitle: false,
        automaticallyImplyLeading: false,
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
              onPressed: () => (
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
                  }))
              ),
              icon: const Icon(Icons.login),
              label: const Text("Se connecter"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: displayContests.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: displayContests[index].status
                            ? Colors.white
                            : Colors.redAccent,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                        child: Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () => {
                                if(displayContests[index].participants.isEmpty){
                                showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: const Text(
                                          "Participer à l'évènement"),
                                      content: DropdownButtonFormField<String>(
                                        value: dropdownValue,
                                        elevation: 16,
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
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () => {
                                            oldContest = Contest(displayContests[index].title, displayContests[index].description, displayContests[index].date, displayContests[index].adress, displayContests[index].photo,displayContests[index].participants, displayContests[index].status),
                                            addParticipants(),
                                            Navigator.pop(context)
                                          },
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              shape:
                                              const StadiumBorder()),
                                          child: const Text(
                                              "Participer"),
                                        ),
                                      ],
                                    ))
                                },
                                displayContests[index].participants.forEach((element) {
                                  if(element["name"] != UserManager.user.username && !displayContests[index].status){
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Participer à l'évènement"),
                                              content: DropdownButtonFormField<String>(
                                                value: dropdownValue,
                                                elevation: 16,
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
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => {
                                                    oldContest = Contest(displayContests[index].title, displayContests[index].description, displayContests[index].date, displayContests[index].adress, displayContests[index].photo,displayContests[index].participants, displayContests[index].status),
                                                    addParticipants(),
                                                    Navigator.pop(context)
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      shape:
                                                      const StadiumBorder()),
                                                  child: const Text(
                                                      "Participer"),
                                                ),
                                              ],
                                            ));
                                  }
                                })
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("${displayContests[index].title}"),
                                      Text(
                                          "Description  : ${displayContests[index].description}"),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: Text(
                                                "Thème : ${displayContests[index].adress}"),
                                            margin: const EdgeInsets.only(
                                                right: 6.0),
                                          ),
                                          Text(
                                              "Date : ${displayContests[index].date}")
                                        ],
                                      )
                                    ],
                                  ),
                                  Image(
                                      image: NetworkImage(
                                          displayContests[index].photo))
                                ],
                              ),
                            ))),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => (takeAllContest()),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        backgroundColor:
                        allEvents ? Colors.blue : Colors.grey),
                    child: const Text("Tous les évènements"),
                  ),
                  ElevatedButton(
                    onPressed: () => (takeMyContest()),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        backgroundColor:
                        allEvents ? Colors.grey : Colors.blue),
                    child: const Text("Mes évènements"),
                  ),
                  ElevatedButton(
                    onPressed: () => (showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text('Ajouter un évènements'),
                            content: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 450,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer un titre',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: titleController,
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer une adresse',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: adressController,
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer une description',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: descriptionController,
                                    ),
                                    TextField(
                                      controller: dateController,
                                      //editing controller of this TextField
                                      decoration: const InputDecoration(
                                          labelText:
                                          "Enter Date" //label text of field
                                      ),
                                      readOnly: true,
                                      //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            //DateTime.now() - not to allow to choose before today.
                                            lastDate: DateTime(2101));

                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                          setState(() {
                                            dateController.text =
                                                formattedDate; //set output date to TextField value.
                                          });
                                        } else {
                                          print("Date is not selected");
                                        }
                                      },
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText:
                                        "Entrer le lien d'une photo",
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: photoController,
                                    ),
                                    Container(
                                      margin:
                                      const EdgeInsets.only(top: 10.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Validate returns true if the form is valid, or false otherwise.
                                          if (_formKey.currentState!
                                              .validate()) {
                                            // If the form is valid, display a snackbar. In the real world,
                                            // you'd often call a server or save the information in a database.
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Processing Data')),
                                            );
                                            addContest();
                                            Navigator.pop(context);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder()),
                                        child: const Text('Submit'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )))),
                    style: ElevatedButton.styleFrom(
                        elevation: 0, shape: const StadiumBorder()),
                    child: const Text("Ajouter"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: IsAdmin.admin == 0 ? const MyNavigationBar() : const AdminNavigationBar(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
