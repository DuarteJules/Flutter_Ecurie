import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../providers/mongodb.dart';
import '../screens/cavaliers_screen.dart';

// instance of MongoDB
var mongodb = DBConnection.getInstance();
class UserCard extends StatelessWidget {
  const UserCard(
    this.name,
    this.mail,
    this.createdAt,
    this.image,
  );

  final String name;
  final String mail;
  final String createdAt;
  final String image;

  void _deleteUSer(name) async {
    var collectionHorse = mongodb.getCollection("horses");
    var collectionUser = mongodb.getCollection("users");
    var isUserOwner = await collectionHorse.findOne({"owner": name});
    if (isUserOwner != null) {
      await collectionHorse.deleteMany(where.eq("owner", isUserOwner["owner"]));
      await collectionUser.deleteOne(where.eq("username", name));
    } else {
      await collectionUser.deleteOne(where.eq("username", name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white54,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(height: 20),
          Image(
              image: NetworkImage(image),
              fit: BoxFit.fill,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white70,
                  alignment: Alignment.center,
                  child: const Image(
                      // IMG URL DIDN'T Work
                      image:
                          AssetImage('assets/images/Image_not_available.png')),
                );
              }),
          Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                "Nom Du cavalier: ${name.toUpperCase()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Email: $mail",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Isncrit depuis le $createdAt",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              ElevatedButton(
                onPressed: () async {
                  _deleteUSer(name);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const CavaliersSceen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text('Supprimer le cavalier'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
