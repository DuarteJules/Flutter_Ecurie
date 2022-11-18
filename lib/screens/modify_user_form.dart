import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;
// import 'package:mongo_dart/mongo_dart.dart';

import '../providers/mongodb.dart';

var mongodb = DBConnection.getInstance();

class ModifyUserForm extends StatefulWidget {
  static const tag = "Modify user form";
  const ModifyUserForm({super.key});

  @override
  State<ModifyUserForm> createState() => _ModifyUserFormState();
}

class _ModifyUserFormState extends State<ModifyUserForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifer votre profil"),
      ),
      body: Center(
          child: Column(children: const [
        MyCustomForm(),
      ])),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  var user = UserManager.user;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final photoController = TextEditingController();
  final telController = TextEditingController();

  @override
  void initState() {
    setState(() {
      nameController.value = (TextEditingValue(text: user.username));
      mailController.value = (TextEditingValue(text: user.mail));
      passwordController.value = (TextEditingValue(text: user.password));
      if (user.age != null) {
        ageController.value = (TextEditingValue(text: user.age.toString()));
      } else {
        ageController.value = (TextEditingValue(text: ''));
      }
      photoController.value = (TextEditingValue(text: user.photo));
      if (user.tel != null || user.tel == '') {
        telController.value = (TextEditingValue(text: user.tel.toString()));
      } else {
        telController.value = (TextEditingValue(text: ''));
      }
    });
    super.initState();
  }

  Future<void> _sendDataBack(BuildContext context) async {
    String name = nameController.text;
    String mail = mailController.text;
    String password = passwordController.text;
    String age = ageController.text;
    String photo = photoController.text;
    String tel = telController.text;


    var collection = mongodb.getCollection('users');
    var u = await collection.findOne({'username': user.username});
    if (u != null) {
      u['username'] = name;
      u['mail'] = mail;
      u['password'] = password;
      u['age'] = age;
      u['image'] = photo;
      u['tel'] = tel;

      // UpdateOne User with the username found in db
      await collection.updateOne(
          dart.where.eq('username', user.username),
          dart.ModifierBuilder()
              .set('username', name)
              .set('mail', mail)
              .set('password', password)
              .set('age', age)
              .set('image', photo)
              .set('tel', tel));

      var userModified = User(name, mail, password, photo, 1, age, tel);
      UserManager.user = userModified;
    }

    Navigator.pop(context, UserManager.user);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Nom d'utilisateur"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: nameController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Mail'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: mailController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Mot de passe'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: passwordController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Photo"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: photoController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Age'),
            controller: ageController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Numero de telephone'),
            controller: telController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _sendDataBack(context);
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
