import 'package:flutter/material.dart';

class CurrentWeekCard extends StatelessWidget {
  const CurrentWeekCard(this.type, this.title, this.description, this.createdAt,
      this.date, this.userParticipate,
      {super.key});

  final String type;
  final String description;
  final String title;
  final String createdAt;
  final String date;
  final bool userParticipate;

  @override
  Widget build(BuildContext context) {
    return userParticipate != false
        ? Card(
            child: ListTile(
              leading: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.green),
                padding: const EdgeInsets.all(16.0),
                child: Text(type,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
              ),
              title: Column(
                children: [
                  Text("Nom: $title"),
                  Text("Description: $description"),
                  Text("Le: $date")
                ],
              ),
              subtitle: Text("Ajouté le: $createdAt"),
            ),
          )
        : Card(
            child: ListTile(
              leading: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.grey),
                padding: const EdgeInsets.all(16.0),
                child: Text(type,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
              ),
              title: Column(
                children: [
                  Text("Nom: $title"),
                  Text("Description $description"),
                  Text("Le: $date")
                ],
              ),
              subtitle: Text("Ajouté le: $createdAt"),
            ),
          );
  }
}
