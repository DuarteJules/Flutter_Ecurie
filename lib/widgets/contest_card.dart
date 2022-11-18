import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../providers/mongodb.dart';
import '../screens/validate_courses_screen.dart';

// instance of MongoDB
var mongodb = DBConnection.getInstance();

class ContestCard extends StatelessWidget {
  const ContestCard(
    this.title,
    this.description,
    this.date,
    this.adress,
    this.photo,
    this.participants,
    this.status,
    this.idCard,
  );

  final String title;
  final String description;
  final String date;
  final String adress;
  final String photo;
  final List<dynamic> participants;
  final bool status;
  final ObjectId idCard;

  // Contest accepted -> status changed in DB
  void _acceptContest(idCard) async {
    var collection = mongodb.getCollection("contest");
    await collection.updateOne(
        where.eq('_id', idCard), ModifierBuilder().set('status', true));
  }

  // Contest refused -> deleted in DB
  void _declineContest(idCard) async {
    var collection = mongodb.getCollection("contest");
    await collection.deleteOne(<String, Object>{"_id": idCard});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: status == 1 ? Colors.greenAccent : Colors.white38,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                "Titre: ${title.toUpperCase()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Description: $description",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Date du concours: $date",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Adresse: $adress",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (status == 1) {
                    return;
                  } else {
                    // TODO  IF course accepted -> disable button for suppress course
                    _acceptContest(idCard);
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const ValidateCourses(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor:
                        status == 1 ? Colors.white54 : Colors.green),
                child: const Text('Accepter le cours'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _declineContest(idCard);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const ValidateCourses(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text('Refuser le cours'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
