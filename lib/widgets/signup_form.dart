import 'package:flutter/material.dart';
import 'package:flutter_ecurie/services/news_feed.dart';

import '../models/user.dart';
import '../providers/mongodb.dart';
import '../screens/home_page.dart';

// instance of MongoDB
var mongodb = DBConnection.getInstance();

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  SignupFormState createState() {
    return SignupFormState();
  }
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
    imageController.dispose();
    super.dispose();
  }

  static _createUser(
      TextEditingController nameController,
      TextEditingController mailController,
      TextEditingController passwordController,
      TextEditingController imageController) async {
    var timestamp = DateTime.now();
    var collection = mongodb.getCollection("users");
    var userNameAlreadyExists =
        await collection.findOne({"username": nameController.text});
    if (userNameAlreadyExists == null) {
      collection.insertOne({
        "username": nameController.text,
        "mail": mailController.text,
        "age": "",
        "password": passwordController.text,
        "image": imageController.text,
        "createdAt": timestamp,
        "tel": "",
        "role": 1
      });
      Newsfeed().insertNews(
          "L'utilisateur ${nameController.text} a été créé.", 'users');
      return true;
    } else {
      return false;
    }
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
              labelText: 'Entrez une adresse mail',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Merci de renseigner une adresse mail';
              }
            },
            controller: mailController,
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Entrez un mot de passe',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Merci de renseigner un mot de passe';
              }
            },
            controller: passwordController,
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText:
                  'Entrez l\'url d\'une image pour votre photo de profil',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Merci de renseigner une url';
              }
            },
            controller: imageController,
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                var isUserCreated = await _createUser(nameController,
                    mailController, passwordController, imageController);
                if (isUserCreated == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Le nom d\'utilisateur existe déjà, merci d\'en choisir un autre')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vous avez bien été crée !')),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const MyHomePage(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
            child: const Text("S'inscrire"),
          ),
        ],
      ),
    );
  }
}
