import 'dart:math';


import 'package:flutter/material.dart';


class UserCard extends StatelessWidget {
  const UserCard(
    this.name,
    this.mail,
    // required this.image,
  );

  final String name;
  final String mail;
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
              Text(
                mail,
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