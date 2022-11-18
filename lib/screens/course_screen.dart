import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/course.dart';
import 'package:flutter_ecurie/models/isAdmin.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/adminNavigation_bar.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:flutter_ecurie/screens/profile.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;

import '../models/user_manager.dart';
import '../providers/nav_non_user.dart';
import '../providers/navigation_bar.dart';
import '../widgets/course_form.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}
const List<String> list = <String>[
  'Carrière',
  "Manège"
];


const List<String> listDiscipline = <String>[
  'Dressage',
  "Saut d'obstacle",
  "Endurance"
];
class _CourseScreenState extends State<CourseScreen> {
  int login = 0;
  bool _connected = UserManager.isUserConnected;
  late String dropdownValue = list.first;
  late String BisdropdownValue = listDiscipline.first;

  List<Course> courses = [];
  List<Course> displayCourses = [];

  bool allCourses = true;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final hourController = TextEditingController();
  final durationController = TextEditingController();
  final disciplineController = TextEditingController();

  late Course oldCourse;

  void getCourses() async {
    var collection = mongodb.getCollection("courses");
    var horsesJson = await collection.find().toList();
    Course course = Course("", "", "", 1, "", "", false, []);
    setState(() {
      horsesJson.forEach((element) {
        courses.add(course.fromJson(element));
      });
    });
    takeAllCourses();
  }

  void _createCourse() async {
    var collection = mongodb.getCollection("courses");
    var timestamp = DateTime.now();
    await collection.insertOne({
      "title": titleController.text,
      "description": descriptionController.text,
      "date": DateTime.parse(dateController.text),
      "hour": hourController.text,
      "duration": durationController.text,
      "discipline": BisdropdownValue,
      "place": dropdownValue,
      "status": 0,
      "createdAt": timestamp,
      "teacher": "François",
      "participants": [],
    });
    setState(() {
      displayCourses.add(Course(titleController.text, descriptionController.text, dateController.text, int.parse(durationController.text), BisdropdownValue, dropdownValue, false,[]));
      titleController.text = "";
      descriptionController.text = "";
      dateController.text = "";
      durationController.text = "";
      hourController.text = "";
    });
  }

  void addParticipants() async {
    oldCourse.participants.add(UserManager.user.username);
    var collection = mongodb.getCollection("courses");
    await collection.updateOne({
      'title': oldCourse.title,
      'description': oldCourse.description,
      'discipline': oldCourse.discipline,
      'place' : oldCourse.place
    }, dart.ModifierBuilder().set('participants', oldCourse.participants));
    setState(() {
      int index = courses.indexWhere((element) =>
      element.title == oldCourse.title &&
          element.description == oldCourse.description &&
          element.date == oldCourse.date &&
          element.duration == oldCourse.duration &&
          element.place == oldCourse.place &&
          element.participants == oldCourse.participants);
      courses[index] = oldCourse;
    });
    takeAllCourses();
  }

  void takeAllCourses() {
    setState(() {
      displayCourses.clear();
      displayCourses.addAll(courses);
      allCourses = true;
    });
  }
  void takeMyCourses() {
    setState(() {
      displayCourses.clear();
      courses.forEach((element) {
        if (element.participants.contains(UserManager.user.username)) {
          displayCourses.add(element);
        }
      });
      allCourses = false;
    });
  }

  Color getCardColor(Course course){
    if(course.participants.contains(UserManager.user.username)){
      return Colors.green;
    }
    if(course.status == true){
      return Colors.white;
    }
    if(course.status == false){
      return Colors.redAccent;
    }
    return Colors.white;
  }

  @override
  void initState() {
    getCourses();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: displayCourses.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: getCardColor(displayCourses[index]),
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                        child: Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () => {
                                if (!displayCourses[index].participants.contains(UserManager.user.username) && displayCourses[index].status)
                                  {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Participer au cour"),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => {
                                                    oldCourse = Course(displayCourses[index].title, displayCourses[index].description, displayCourses[index].date,displayCourses[index].duration, displayCourses[index].discipline ,displayCourses[index].place,displayCourses[index].status, displayCourses[index].participants),
                                                    addParticipants(),
                                                    Navigator.pop(context)
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      elevation: 0,
                                                      shape:
                                                          const StadiumBorder()),
                                                  child:
                                                      const Text("Participer"),

                                                ),
                                              ],
                                            ))
                                  }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(displayCourses[index].title),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 6.0),
                                            child: Text(
                                                "Description  : ${displayCourses[index].description}"),
                                          ),

                                          Text(
                                              "Lieu  : ${displayCourses[index].place}"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 6.0),
                                            child: Text("Discipline : ${displayCourses[index].discipline}"),
                                          ),
                                          Text(
                                              "Date : ${displayCourses[index].date}")
                                        ],
                                      )
                                    ],
                                  ),
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
                    onPressed: () => (takeAllCourses()),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        backgroundColor:
                            allCourses ? Colors.blue : Colors.grey),
                    child: const Text("Tous les cours"),
                  ),
                  ElevatedButton(
                    onPressed: () => (takeMyCourses()),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        backgroundColor:
                            allCourses ? Colors.grey : Colors.blue),
                    child: const Text("Mes cours"),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                    {showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                                title: const Text('Ajouter un cour'),
                                content: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 600,
                                    child: Form(
                                      key: _formKey,
                                      child: Column(children: <Widget>[
                                        TextFormField(
                                          // The validator receives the text that the user has entered.
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Entrez le titre du cours',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Entrez du texte s'il vous plait";
                                            }
                                          },
                                          controller: titleController,
                                        ),
                                        TextField(
                                          controller: dateController, //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              labelText: "Chosissez une date" //label text of field
                                          ),
                                          readOnly: true, //set it true, so that user will not able to edit text
                                          onTap: () async {
                                            DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime
                                                    .now(), //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2101));
                                            if (pickedDate != null) {
                                              String formattedDate =
                                              DateFormat('yyyy-MM-dd').format(pickedDate);
                                              setState(() {
                                                dateController.text =
                                                    formattedDate; //set output date to TextField value.
                                              });
                                            } else {
                                              print("Date is not selected");
                                            }
                                          },
                                        ),
                                        TextField(
                                          controller: hourController, //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              labelText: "Choisissez une heure" //label text of field
                                          ),
                                          readOnly: true, //set it true, so that user will not able to edit text
                                          onTap: () async {
                                            final selectedTime = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                              builder: (BuildContext context, Widget? child) {
                                                return MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(alwaysUse24HourFormat: true),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            if (selectedTime != null) {
                                              final text;
                                              text = selectedTime.format(context);
                                              setState(() {
                                                hourController.text = text;
                                              });
                                            }
                                          },
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: dropdownValue,
                                          elevation: 16,
                                          decoration: const InputDecoration(
                                              labelText: "Choisissez un lieu" //label text of field
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
                                        TextFormField(
                                          // The validator receives the text that the user has entered.
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Entrez la description du cours',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Entrez du texte s'il vous plait";
                                            }
                                          },
                                          controller: descriptionController,
                                        ),
                                        TextFormField(
                                          // The validator receives the text that the user has entered.
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            labelText: 'Entrez la durée du cours',
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return "Entrez une durée s'il vous plaît";
                                            }
                                          },
                                          controller: durationController,
                                        ),
                                        DropdownButtonFormField<String>(
                                          value: BisdropdownValue,
                                          elevation: 16,
                                          decoration: const InputDecoration(
                                              labelText: "Choisissez une Discipline" //label text of field
                                          ),
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              BisdropdownValue = value!;
                                            });
                                          },
                                          items: listDiscipline.map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Validate returns true if the form is valid, or false otherwise.
                                            if (_formKey.currentState!.validate()) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Le cours a bien été créé')),
                                              );
                                              _createCourse();
                                              Navigator.pop(context);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                                          child: const Text('Ajouter'),
                                        ),
                                      ]),
                                    ))
                            )
                    )
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0, shape: const StadiumBorder()),
                    child: const Text("Ajouter"),
                  ),
                ],
              ),
            ),
          ],
        ),

      ])),
      bottomNavigationBar: IsAdmin.admin == 0 && UserManager.isUserConnected == true ? const MyNavigationBar() : IsAdmin.admin == 0 && UserManager.isUserConnected == false ? const NavNonUser() : const AdminNavigationBar(),
    );
  }
}
