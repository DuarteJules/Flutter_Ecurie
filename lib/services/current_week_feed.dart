import 'package:mongo_dart/mongo_dart.dart';

import '../providers/mongodb.dart';

var mongodb = DBConnection.getInstance();
var courses_collection = mongodb.getCollection('courses');
var contests_collection = mongodb.getCollection('contest');
var events_collection = mongodb.getCollection('events');

// returns current week's monday date
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

// returns current week's sunday date
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

DateTime today = DateTime.now();
DateTime firstDayOfWeek = findFirstDateOfTheWeek(today);
DateTime lastDayOfWeek = findLastDateOfTheWeek(today);

class CurrentWeekFeed {
  // Function to get all validated events sorted by date (descending)
  getEvents() {
    var events = events_collection
        .find(where
            .inRange('date', firstDayOfWeek, lastDayOfWeek)
            .eq("status", true)
            .sortBy("date"))
        .toList();
    return events;
  }

  // Function to get all validated courses sorted by date (descending)
  getCourses() {
    var courses = courses_collection
        .find(where
            .inRange('date', firstDayOfWeek, lastDayOfWeek)
            .eq("status", 1)
            .sortBy("date"))
        .toList();
    return courses;
  }

  // Function to get all validated contests sorted by date (descending)
  getContests() {
    var contests = contests_collection
        .find(where
            .inRange('date', firstDayOfWeek, lastDayOfWeek)
            .eq("status", true)
            .sortBy("date"))
        .toList();
    return contests;
  }
}
