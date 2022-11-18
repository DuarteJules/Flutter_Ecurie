import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  const NewsCard(this.description, this.label, this.createdAt, {super.key});

  final String description;
  final String label;
  final String createdAt;

  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.green),
          padding: const EdgeInsets.all(16.0),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        title: Text(description),
        subtitle: Text(createdAt),
      ),
    );
  }
}
