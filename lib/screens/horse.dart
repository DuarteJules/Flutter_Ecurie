import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ecurie/screens/home_page.dart';
import 'package:flutter_ecurie/models/horse.dart';

class HorseList extends StatefulWidget {
  static const tag = "Horse List";

  const HorseList({super.key});

  @override
  State<HorseList> createState() => _HorseListState();
}

class _HorseListState extends State<HorseList> {
  int _selectedIndex = 0;
  bool _connected = true;

  List<Horse> chevaux = [
    Horse("Petit tonnerre", "https://www.wall-art.de/out/pictures/generated/product/2/780_780_80/ya1009-wandtattoo-yakari-kleiner-donner-web-einzel.jpg", "", 1, "cheval", "male", "chasse", "yakari", ""),
    Horse("Petit tonnerre", "https://www.wall-art.de/out/pictures/generated/product/2/780_780_80/ya1009-wandtattoo-yakari-kleiner-donner-web-einzel.jpg", "", 1, "cheval", "male", "chasse", "yakari", ""),
    Horse("Petit tonnerre", "https://www.wall-art.de/out/pictures/generated/product/2/780_780_80/ya1009-wandtattoo-yakari-kleiner-donner-web-einzel.jpg", "", 1, "cheval", "male", "chasse", "yakari", ""),
    Horse("Petit tonnerre", "https://www.wall-art.de/out/pictures/generated/product/2/780_780_80/ya1009-wandtattoo-yakari-kleiner-donner-web-einzel.jpg", "", 1, "cheval", "male", "chasse", "yakari", ""),
  ];

  bool list = true;

  void _onItemTapped(int index) {
    switch (index) {
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => MyHomePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        ;
    }
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
                child:  ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: chevaux.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 70,
                      margin: const EdgeInsets.all(3),
                      child: Center(
                          child: Card(
                            elevation: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Nom : ${chevaux[index].name}"),
                                    Text("Race : ${chevaux[index].race}"),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Age : ${chevaux[index].age.toString()}"),
                                    Text("Specialité : ${chevaux[index].specialty}"),
                                  ],
                                ),
                                Image(image: NetworkImage(chevaux[index].photo))
                              ],
                            ),
                          )
                      ),
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
                    onPressed: () => (print("Tout les chevaux")),
                    style: ElevatedButton.styleFrom(
                        elevation: 0, shape: const StadiumBorder()),
                    child: const Text("Tous les chevaux"),
                  ),
                  ElevatedButton(
                    onPressed: () => (print("Mes chevaux")),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: const StadiumBorder(),
                        backgroundColor: list ? Colors.grey : Colors.blue),
                    child: const Text("Mes chevaux"),
                  ),
                  ElevatedButton(
                    onPressed: () => (print("ajouter un cheval")),
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
      bottomNavigationBar: BottomNavigationBar(
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 20),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
