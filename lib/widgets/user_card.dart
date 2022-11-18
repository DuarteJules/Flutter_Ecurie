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
            ],
          )
        ],
      ),
    );
  }
}
