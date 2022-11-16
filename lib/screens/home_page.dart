import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user.dart';
import 'package:flutter_ecurie/screens/auth_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/user_manager.dart';
import '../providers/mongodb.dart';
import '../widgets/user_card.dart';
import 'package:intl/intl.dart';

var mongodb = DBConnection.getInstance();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  bool _connected = false;
  List userCards = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List> getListUSer() async {
    var userCollection = mongodb.getCollection('users');
    var listOfUser = await userCollection.find().toList();
    List items = [];
    for (int i = 0; i < listOfUser.length; i++) {
      var createdAt = listOfUser[i]["createdAt"];
      var formattedDate;
      if (createdAt != null) {
        formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
        var userCard = UserCard(
            listOfUser[i]["userName"], listOfUser[i]["email"], formattedDate);
        items.add(userCard);
      } else {
        var userCard =
            UserCard(listOfUser[i]["userName"], listOfUser[i]["email"], "null");
        items.add(userCard);
      }
    }
    return items;
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
              onPressed: () => (print(_connected)),
              icon: const Icon(Icons.person),
              label: const Text("profile"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
          else
            ElevatedButton.icon(
              onPressed: () => {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()))
                    .then((response) => setState(() => {
                          // If user is connected to see his profile
                          _connected = true
                        })),
              },
              icon: const Icon(Icons.login),
              label: const Text("Se connecter"),
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
            )
        ],
      ),
      body: FutureBuilder(
        future: getListUSer(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Center(
                    // child: Text(args.toString())
                    child: Column(children: <Widget>[
                      snapshot.data![index],
                    ]),
                  );
                });
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
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
