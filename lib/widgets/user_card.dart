import 'dart:math';

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white54,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(
              image: NetworkImage(image, scale: 5),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.amber,
                  alignment: Alignment.center,
                  child: const Image(
                      // IMG URL DIDN'T Work
                      image: AssetImage('assets/images/testjpeg.jpeg')),
                );
              }),
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
