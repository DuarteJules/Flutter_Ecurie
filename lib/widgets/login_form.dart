import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user_manager.dart';

import 'package:flutter_ecurie/models/user.dart';
import '../providers/mongodb.dart';
import '../screens/home_page.dart';

// instance of MongoDB
var mongodb = DBConnection.getInstance();

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}


class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  static _loginUser(TextEditingController nameController,
      TextEditingController passwordController) async {
    // print(nameController.text);
    var collection = mongodb.getCollection("users");
    var user = await collection.findOne(
        {"username": nameController.text, "password": passwordController.text});
    return user;
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Entrez un nom d\'utilisateur',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Merci de renseigner du texte';
              }
            },
            controller: nameController,
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Entrez votre mot de passe',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Merci de renseigner votre mot de passe';
              }
            },
            controller: passwordController,
          ),
          ElevatedButton(
            onPressed: () async  {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                
                final isUserCorrect = await _loginUser(nameController, passwordController);
                if (isUserCorrect == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Votre nom d\'utilisateur ou mot de passe est incorrecte.')),
                  );
                } else {
                  // TODO : retreive role of user
                  var userLogged = User(
                      isUserCorrect["username"],
                      isUserCorrect["mail"],
                      isUserCorrect["password"],
                      isUserCorrect["image"],
                      isUserCorrect["role"],
                      isUserCorrect['age'],
                      isUserCorrect['tel']);
                  UserManager.user = userLogged;
                  var userConnected = UserManager.connectUser();
                  Navigator.pop(context, userConnected);
                }
              }
            },
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
