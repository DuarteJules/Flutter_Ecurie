import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/providers/navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ecurie/screens/home_page.dart';
import 'package:flutter_ecurie/models/horse.dart';

import '../providers/mongodb.dart';

var mongodb = DBConnection.getInstance();

class HorseList extends StatefulWidget {
  static const tag = "Horse List";

  const HorseList({super.key});

  @override
  State<HorseList> createState() => _HorseListState();
}

const List<String> list = <String>[
  'Dressage',
  "Saut d'obstacle",
  'Endurance',
  'Compétition'
];

class _HorseListState extends State<HorseList> {
  bool _connected = UserManager.isUserConnected;
  late String dropdownValue = list.first;
  late String DPdropdownValue;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final photoController = TextEditingController();
  final ageController = TextEditingController();
  final raceController = TextEditingController();
  final sexController = TextEditingController();
  final robeController = TextEditingController();
  final ownerController = TextEditingController();

  List<Horse> horses = [];
  List<Horse> displayHorses = [];

  bool allHorses = true;

  late Horse oldHorse;

  void getHorses() async {
    var collection = mongodb.getCollection("horses");
    var horsesJson = await collection.find().toList();
    Horse horse = Horse("", "", "", "", "", "", "", "", []);
    setState(() {
      horsesJson.forEach((element) {
        horses.add(horse.fromJson(element));
      });
    });
    takeAllHorses();
  }

  void addHorses() async {
    var collection = mongodb.getCollection("horses");
    await collection.insertOne({
      'name': nameController.text,
      'age': ageController.text,
      'photo': photoController.text,
      'robe': robeController.text,
      'sex': sexController.text,
      'specialty': dropdownValue,
      'owner': UserManager.user.username,
      'race': raceController.text,
      'dp': []
    });
    setState(() {
      Horse horse = Horse(
          nameController.text,
          photoController.text,
          robeController.text,
          ageController.text,
          raceController.text,
          sexController.text,
          dropdownValue,
          UserManager.user.username,
          []);
      horses.add(horse);
      takeAllHorses();
    });
    nameController.text = "";
    ageController.text = "";
    photoController.text = "";
    robeController.text = "";
    sexController.text = "";
    raceController.text = "";
  }

  void takeAllHorses() {
    setState(() {
      displayHorses.clear();
      displayHorses.addAll(horses);
      allHorses = true;
    });
  }
  void takeMyHorses() {
    setState(() {
      displayHorses.clear();
      horses.forEach((element) {
        if (element.owner == UserManager.user.username) {
          displayHorses.add(element);
        }
      });
      allHorses = false;
    });
  }

  void updateHorse() async {
    Horse newHorse = Horse(nameController.text, photoController.text, robeController.text, ageController.text, raceController.text, sexController.text, dropdownValue, "test3", []);
    var collection = mongodb.getCollection("horses");
    await collection.replaceOne({'name' : oldHorse.name,'photo': oldHorse.photo,'robe': oldHorse.robe,'age' : oldHorse.age, 'race' : oldHorse.race, 'sex' : oldHorse.sex, 'specialty' : oldHorse.specialty, 'owner': oldHorse.owner, 'dp' : oldHorse.dp},
        {
        'name' : newHorse.name,
          'photo': newHorse.photo,
          'robe': newHorse.robe,
          'age' : newHorse.age,
          'race' : newHorse.race,
          'sex' : newHorse.sex,
          'specialty' : newHorse.specialty,
          'owner': newHorse.owner,
          'dp' : newHorse.dp
    });
    setState(() {
      int index = horses.indexWhere((element) =>
      element.name == oldHorse.name &&
          element.photo == oldHorse.photo &&
          element.robe == oldHorse.robe &&
          element.age == oldHorse.age &&
          element.race == oldHorse.race &&
          element.sex == oldHorse.sex &&
          element.specialty == oldHorse.specialty &&
          element.owner == oldHorse.owner &&
          element.dp == oldHorse.dp
      );
      horses[index] = newHorse;
    });
    takeAllHorses();
  }

  void addDp() async{
    oldHorse.dp.add(UserManager.user.username);
    var collection = mongodb.getCollection("horses");
    await collection.replaceOne({'name' : oldHorse.name,'photo': oldHorse.photo,'robe': oldHorse.robe,'age' : oldHorse.age, 'race' : oldHorse.race, 'sex' : oldHorse.sex, 'specialty' : oldHorse.specialty, 'owner': oldHorse.owner},
        {
          'name' : oldHorse.name,
          'photo': oldHorse.photo,
          'robe': oldHorse.robe,
          'age' : oldHorse.age,
          'race' : oldHorse.race,
          'sex' : oldHorse.sex,
          'specialty' : oldHorse.specialty,
          'owner': oldHorse.owner,
          'dp' : oldHorse.dp
        });
    setState(() {
      int index = horses.indexWhere((element) =>
      element.name == oldHorse.name &&
          element.photo == oldHorse.photo &&
          element.robe == oldHorse.robe &&
          element.age == oldHorse.age &&
          element.race == oldHorse.race &&
          element.sex == oldHorse.sex &&
          element.specialty == oldHorse.specialty &&
          element.owner == oldHorse.owner &&
          element.dp == oldHorse.dp
      );
      horses[index] = oldHorse;
    });
    takeAllHorses();
  }

  @override
  void initState() {
    getHorses();
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
              onPressed: () => (print(_connected)),
              icon: const Icon(Icons.person),
              label: const Text("profile"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
          else
            ElevatedButton.icon(
              onPressed: () => (print(_connected)),
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
                itemCount: displayHorses.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 70,
                    margin: const EdgeInsets.all(3),
                    child: Center(
                        child: Card(
                      elevation: 4,
                      child: InkWell(
                        onTap: ()=>{
                          if((displayHorses[index].owner == UserManager.user.username)){
                            oldHorse = Horse(displayHorses[index].name, displayHorses[index].photo, displayHorses[index].robe, displayHorses[index].age, displayHorses[index].race, displayHorses[index].sex , displayHorses[index].specialty, displayHorses[index].owner, displayHorses[index].dp),
                          nameController.text = displayHorses[index].name ,
                          ageController.text = displayHorses[index].age.toString() ,
                          photoController.text = displayHorses[index].photo,
                          robeController.text = displayHorses[index].robe ,
                          sexController.text = displayHorses[index].sex ,
                          raceController.text = displayHorses[index].race,
                          dropdownValue = displayHorses[index].specialty,
                            if(displayHorses[index].dp.isNotEmpty)(
                                DPdropdownValue = displayHorses[index].dp.first
                            ),
                          showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: const Text('Modifier mon cheval'),
                              content: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 800,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Entrer un nom',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Entrer du texte s'il vous plait";
                                          }
                                        },
                                        controller: nameController,
                                      ),
                                      TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Entrer une race',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Entrer du texte s'il vous plait";
                                          }
                                        },
                                        controller: raceController,
                                      ),
                                      TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Entrer un age',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Entrer du texte s'il vous plait";
                                          }
                                        },
                                        controller: ageController,
                                      ),
                                      TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Entrer un sex',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Entrer du texte s'il vous plait";
                                          }
                                        },
                                        controller: sexController,
                                      ),
                                      TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: "Entrer le lien d'une photo",
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Entrer du texte s'il vous plait";
                                          }
                                        },
                                        controller: photoController,
                                      ),
                                      TextFormField(
                                        // The validator receives the text that the user has entered.
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Entrer une couleur de robe',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Entrer du texte s'il vous plait";
                                          }
                                        },
                                        controller: robeController,
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: dropdownValue,
                                        elevation: 16,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          labelText: 'Choississez une spécialité',
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
                                      if(displayHorses[index].dp.isNotEmpty)(
                                          DropdownButtonFormField<String>(
                                            value: DPdropdownValue,
                                            elevation: 16,
                                            decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Liste des demis pensionnaires de votre cheval',
                                            ),
                                            onChanged: (String? value) {
                                              setState(() {
                                                DPdropdownValue = value!;
                                              });
                                            },
                                            items: displayHorses[index].dp.map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                          )
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10.0),
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
                                                    content:
                                                    Text('Processing Data')),
                                              );
                                              updateHorse();
                                              Navigator.pop(context);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder()),
                                          child: const Text('Modifier'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )))
                          }
                          else{
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Devenir demi pensionnaire'),
                                    content: const Text("Voulez vous devenir demi pensionnaire de ce cheval ?"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () =>{
                                        oldHorse = Horse(displayHorses[index].name, displayHorses[index].photo, displayHorses[index].robe, displayHorses[index].age, displayHorses[index].race, displayHorses[index].sex , displayHorses[index].specialty, displayHorses[index].owner, displayHorses[index].dp),
                                        addDp(),
                                          Navigator.pop(context)
                                        },
                                        child: const Text("Oui")),
                                    ElevatedButton(
                                        onPressed: () =>{
                                          Navigator.pop(context)
                                        },
                                        child: const Text("Non"))
                                  ],
                                ))
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Nom : ${displayHorses[index].name}"),
                                Text("Race : ${displayHorses[index].race}"),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                    "Age : ${displayHorses[index].age.toString()}"),
                                Text(
                                    "Specialité : ${displayHorses[index].specialty}"),
                              ],
                            ),
                            Image(image: NetworkImage(displayHorses[index].photo))
                          ],
                        ),
                      )
                    )),
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
                    onPressed: () => (takeAllHorses()),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        backgroundColor: allHorses ? Colors.blue : Colors.grey),
                    child: const Text("Tous les chevaux"),
                  ),
                  ElevatedButton(
                    onPressed: () => (takeMyHorses()),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        backgroundColor: allHorses ? Colors.grey : Colors.blue),
                    child: const Text("Mes chevaux"),
                  ),
                  ElevatedButton(
                    onPressed: () => (showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text('Ajouter un cheval'),
                            content: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 800,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer un nom',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: nameController,
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer une race',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: raceController,
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer un age',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: ageController,
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer un sex',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: sexController,
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: "Entrer le lien d'une photo",
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: photoController,
                                    ),
                                    TextFormField(
                                      // The validator receives the text that the user has entered.
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Entrer une couleur de robe',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Entrer du texte s'il vous plait";
                                        }
                                      },
                                      controller: robeController,
                                    ),
                                    DropdownButtonFormField<String>(
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
                                    Container(
                                      margin: const EdgeInsets.only(top: 10.0),
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
                                                  content:
                                                      Text('Processing Data')),
                                            );
                                            addHorses();
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
      bottomNavigationBar: const MyNavigationBar()
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
