import 'dart:math';

import 'package:flutter/material.dart';

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
  );

  final String title;
  final String description;
  final String date;
  final String hour;
  final String duration;
  final String discipline;
  final String place;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white54,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                title.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                description,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                date,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                hour,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                duration,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                discipline,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                place,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                createdAt,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }
}
