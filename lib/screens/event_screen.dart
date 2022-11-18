import 'package:flutter_ecurie/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/adminNavigation_bar.dart';
import 'package:flutter_ecurie/providers/navigation_bar.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/event_details_screen.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;


import '../models/isAdmin.dart';
import '../providers/mongodb.dart';
import '../providers/nav_non_user.dart';
import '../services/news_feed.dart';

var mongodb = DBConnection.getInstance();

class EventList extends StatefulWidget {
  static const tag = "Event List";

  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool _connected = UserManager.isUserConnected;
  late String DPdropdownValue;

  final _formKey = GlobalKey<FormState>();
  final themeController = TextEditingController();
  final photoController = TextEditingController();
  final dateController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Event> events = [];
  List<Event> displayEvents = [];

  bool allEvents = true;

  late Event oldEvent;

  void getEvents() async {
    var collection = mongodb.getCollection("events");
    var horsesJson = await collection.find().toList();
    Event event = Event("", "", "", "", [], "", false);
    setState(() {
      horsesJson.forEach((element) {
        events.add(event.fromJson(element));
      });
    });
    takeAllEvents();
  }

  void addEvent() async {
    var collection = mongodb.getCollection("events");
    await collection.insertOne({
      'theme': themeController.text,
      'date': DateTime.parse(dateController.text),
      'photo': photoController.text,
      'description': descriptionController.text,
      'title': titleController.text,
      'status': false,
      'participants': [UserManager.user.username],
      'createdAt' : DateTime.now()
    });
    setState(() {
      Event event = Event(
        themeController.text,
        photoController.text,
        dateController.text,
        descriptionController.text,
        [UserManager.user.username],
        titleController.text,
        false,
      );
      events.add(event);
      takeAllEvents();
    });
    themeController.text = "";
    dateController.text = "";
    photoController.text = "";
    descriptionController.text = "";
    titleController.text = "";
    Newsfeed().insertNews("L'évènement ${titleController.text} a été créé.", 'event');
  }

  void addParticipants() async {
    oldEvent.participants.add(UserManager.user.username);
    var collection = mongodb.getCollection("events");
    await collection.updateOne({
      'title': oldEvent.title,
      'photo': oldEvent.photo,
      'description': oldEvent.description,
      'theme': oldEvent.theme,
      'status': oldEvent.status
    }, dart.ModifierBuilder().set('participants', oldEvent.participants));
    setState(() {
      int index = events.indexWhere((element) =>
          element.title == oldEvent.title &&
          element.photo == oldEvent.photo &&
          element.date == oldEvent.date &&
          element.description == oldEvent.description &&
          element.theme == oldEvent.theme &&
          element.participants == oldEvent.participants &&
          element.status == oldEvent.status);
      events[index] = oldEvent;
    });
    takeAllEvents();
  }

  void takeAllEvents() {
    setState(() {
      displayEvents.clear();
      displayEvents.addAll(events);
      allEvents = true;
    });
  }

  void takeMyEvents() {
    setState(() {
      displayEvents.clear();
      events.forEach((element) {
        if (element.participants.contains(UserManager.user.username)) {
          displayEvents.add(element);
        }
      });
      allEvents = false;
    });
  }

  Color getCardColor(Event event){
    if(event.participants.contains(UserManager.user.username)){
      return Colors.green;
    }
    if(event.status == true){
      return Colors.white;
    }
    if(event.status == false){
      return Colors.redAccent;
    }
    return Colors.white;
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
                  itemCount: displayEvents.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 70,
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: getCardColor(displayEvents[index]),
                          borderRadius: BorderRadius.circular(7)),
                      child: Center(
                          child: Card(
                              elevation: 4,
                              child: InkWell(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventDetails(event: displayEvents[index])))
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("${displayEvents[index].title}"),
                                        Text(
                                            "Description  : ${displayEvents[index].description}"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              child: Text(
                                                  "Thème : ${displayEvents[index].theme}"),
                                              margin: const EdgeInsets.only(
                                                  right: 6.0),
                                            ),
                                            Text(
                                                "Date : ${displayEvents[index].date}")
                                          ],
                                        )
                                      ],
                                    ),
                                    Image(
                                        image: NetworkImage(
                                            displayEvents[index].photo))
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
                      onPressed: () => (takeAllEvents()),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: const StadiumBorder(),
                          backgroundColor:
                              allEvents ? Colors.blue : Colors.grey),
                      child: const Text("Tous les évènements"),
                    ),
                    ElevatedButton(
                      onPressed: () => (takeMyEvents()),
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
                                          labelText: 'Entrer un thème',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Entrer du texte s'il vous plait";
                                          }
                                        },
                                        controller: themeController,
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
                                              addEvent();
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
        bottomNavigationBar: IsAdmin.admin == 0 && UserManager.isUserConnected == true ? const MyNavigationBar() : IsAdmin.admin == 0 && UserManager.isUserConnected == false ? const NavNonUser() : const AdminNavigationBar(),
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
