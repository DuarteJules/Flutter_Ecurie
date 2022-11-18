import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../providers/mongodb.dart';
import '../screens/validate_courses_screen.dart';

// instance of MongoDB
var mongodb = DBConnection.getInstance();

class EventCard extends StatelessWidget {
  const EventCard(
    this.theme,
    this.photo,
    this.date,
    this.description,
    this.participants,    
    this.title,
    this.status,
    this.idCard,
  );


  final String theme;
  final String photo;
  final String date;
  final String description;
  final List<dynamic> participants;
  final String title;
  final bool status;
  final ObjectId idCard;
  
  

  void _acceptCourse(idCard) async {
    var collection = mongodb.getCollection("events");
    await collection.updateOne(
        where.eq('_id', idCard), ModifierBuilder().set('status', true));
  }

  void _declineCourse(idCard) async {
    var collection = mongodb.getCollection("events");
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
                "Thème: $theme",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Description: $description",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Date de l'événement:  $date",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (status == 1) {
                    return;
                  } else {
                    // TODO  IF course accepted -> disable button for suppress course
                    _acceptCourse(idCard);
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
                  _declineCourse(idCard);
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
