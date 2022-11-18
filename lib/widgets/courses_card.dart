import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../providers/mongodb.dart';
import '../screens/validate_courses_screen.dart';

// instance of MongoDB
var mongodb = DBConnection.getInstance();
var timestamp = DateTime.now();

class CoursesCard extends StatelessWidget {
  const CoursesCard(
    this.title,
    this.description,
    this.date,
    this.hour,
    this.duration,
    this.discipline,
    this.place,
    this.createdAt,
    this.idCard,
    this.status,
  );

  final String title;
  final String description;
  final String date;
  final String hour;
  final String duration;
  final String discipline;
  final String place;
  final String createdAt;
  final ObjectId idCard;
  final int status;

  // Course accepted -> status changed in DB
  void _acceptCourse(idCard) async {
    var collection = mongodb.getCollection("courses");
    await collection.updateOne(
        where.eq('_id', idCard), ModifierBuilder().set('status', 1));
  }

  // Course refused -> deleted in DB
  void _declineCourse(idCard) async {
    var collection = mongodb.getCollection("courses");
    await collection.deleteOne(<String, Object>{"_id": idCard});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: status == 1 && timestamp.isAfter(DateTime.parse(date))
          ? Colors.greenAccent
          : status == 0 && timestamp.isAfter(DateTime.parse(date))
              ? Colors.white38
              : Colors.redAccent,
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
                "Date du cours prévue: $date",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Heure du cours: $hour",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Durée du cours: $duration",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Discipline prévue: $discipline",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Endroit: $place",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Cours créé le $createdAt",
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
