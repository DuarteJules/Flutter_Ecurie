import 'package:flutter/material.dart';
import 'package:flutter_ecurie/services/news_feed.dart';

import '../models/user.dart';
import '../providers/mongodb.dart';

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

  void _createUser(TextEditingController nameController, TextEditingController mailController, TextEditingController passwordController, TextEditingController imageController) {
    setState(() {
      var timestamp = DateTime.now();
      var collection = mongodb.getCollection("users");
      collection.insertOne({
        "username": nameController.text,
        "mail": mailController.text,
        "age": "",
        "password": passwordController.text,
        "image": imageController.text,
        "createdAt": timestamp,
        "tel": "",
      });
    });

    Newsfeed().insertNews("L'utilisateur ${nameController.text} a été créé.", 'users');
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
              labelText: 'Entrez l\'url d\'une image pour votre photo de profil',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Merci de renseigner une url';
              }
            },
            controller: imageController,
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                _createUser(nameController, mailController, passwordController, imageController);
                Navigator.pop(context, false);
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
