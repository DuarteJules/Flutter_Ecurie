import 'dart:math';


import 'package:flutter/material.dart';


class HorsesCard extends StatelessWidget {
  const HorsesCard(
    this.name,
    this.breed,
    this.year,
    this.createdAt,
    // required this.image,
  );

  final String name;
  final String breed;
  final int year;
  final String createdAt;
  // final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white54,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // TODO Put img when all users will have correct url img
          // Image(
          //   image: NetworkImage(image, scale: 5),
          // ),
          Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // Text(
              //   mail,
              //   softWrap: false,
              //   overflow: TextOverflow.ellipsis,
              // ),
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