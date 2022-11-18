import 'package:intl/intl.dart';

class Course{
  late String title;
  late String description;
  late String date;
  late String hour;
  late int duration;
  late String discipline;
  late String place;
  late bool status;
  late String teacher;
  late List participants;
  late DateTime createdAt;

  Course(this.title, this.description, this.date, this.duration,
      this.discipline, this.place, this.status, this.participants);

  fromJson(Map<String, dynamic> json){

    return Course(json['title'], json['description'], DateFormat('yyyy-MM-dd').format(json["date"]), int.parse(json['duration']), json['discipline'], json['place'], json['status'] == 0 ? false : true, List<String>.from(json['participants'] as List) );
  }
}