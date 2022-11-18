import 'dart:convert';

import 'package:flutter_ecurie/models/contestCategory.dart';
import 'package:intl/intl.dart';

class Contest{
  late String title;
  late String description;
  late String date;
  late String adress;
  late String photo;
  late List<dynamic> participants;
  late bool status;

  Contest(this.title, this.description, this.date, this.adress, this.photo,
      this.participants, this.status);

  fromJson(Map<String, dynamic> json){
    return Contest(json['title'], json['description'], DateFormat('yyyy-MM-dd').format(json["date"]), json["adress"] , json['photo'], json['participants'], json['status'] );
  }
}