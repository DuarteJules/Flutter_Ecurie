import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/screens/modify_user_form.dart';

import '../models/user.dart';

class MyProfile extends StatefulWidget {
  static const tag = "profile page";
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var user = UserManager.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.all(20),
            width: 225,
            height: 225,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(user.photo.toString()), fit: BoxFit.fill),
            ),
          ),
          Text('Nom : ${user.username}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('mail : ${user.mail}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('role : ${user.role}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('téléphone : ${user.tel != '' ? user.tel : 'Non spécifié'}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('age : ${user.age ?? 'Non spécifié'}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ModifyUserForm())).then((response) => setState(() => {
                      user = response
                    })),
            icon: const Icon(Icons.person),
            label: const Text("Modifier mon profil"),
            style: ElevatedButton.styleFrom(
                elevation: 0, shape: const StadiumBorder()),
          )
        ]),
      ),
    );
  }
}
