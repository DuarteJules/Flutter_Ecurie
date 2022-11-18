import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;

import '../main.dart';
import '../providers/mongodb.dart';

var mongodb = DBConnection.getInstance();

class ForgottenPasswordForm extends StatefulWidget {
  static const tag = "Modify user form";

  const ForgottenPasswordForm({super.key});

  @override
  State<ForgottenPasswordForm> createState() => _ForgottenPasswordFormState();
}

class _ForgottenPasswordFormState extends State<ForgottenPasswordForm>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mot de passe oublié"),
      ),
      body: Center(
          child: Column(
              children: const [
                ForgottenPasswordCustomForm(),
              ]
          )
      ),
    );
  }
}

class ForgottenPasswordCustomForm extends StatefulWidget {
  const ForgottenPasswordCustomForm({super.key});

  @override
  ForgottenPasswordCustomFormState createState() {
    return ForgottenPasswordCustomFormState();
  }
}

class ForgottenPasswordCustomFormState extends State<ForgottenPasswordCustomForm>{

  final _formKey = GlobalKey<FormState>();

  final forgottenUsernameController = TextEditingController();
  final forgottenMailController = TextEditingController();
  final forgottenPasswordController = TextEditingController();



  void dispose() {
    // Clean up the controller when the widget is disposed.
    forgottenUsernameController.dispose();
    forgottenMailController.dispose();
    forgottenPasswordController.dispose();
    super.dispose();
  }


  Future<void> _forgotPassword(BuildContext context) async {
    String username = forgottenUsernameController.text;
    String mail = forgottenMailController.text;
    String password = forgottenPasswordController.text;
    var collection = mongodb.getCollection("users");

    var userFound = await collection.findOne(dart.where.eq("username", username));
    if (userFound != null){
      await collection.updateOne(dart.where.eq('username', username),dart.ModifierBuilder().set('password', password));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nom d'utilisateur"
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },

            controller: forgottenUsernameController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mail'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: forgottenMailController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mot de passe'
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: forgottenPasswordController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _forgotPassword(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0, shape: const StadiumBorder()),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}