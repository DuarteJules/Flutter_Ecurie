import 'package:flutter/material.dart';
import 'package:flutter_ecurie/widgets/courses_card.dart';
import 'package:flutter_ecurie/widgets/event_card.dart';

import '../providers/mongodb.dart';
import 'package:intl/intl.dart';

import 'contest_card.dart';
import 'user_card.dart';

var mongodb = DBConnection.getInstance();

class AskedEventList extends StatefulWidget {
  const AskedEventList({Key? key}) : super(key: key);

  @override
  _AskedCoursesListState createState() => _AskedCoursesListState();
}

class _AskedCoursesListState extends State<AskedEventList> {
  Future<List> getListAskedCourses() async {
    var userCollection = mongodb.getCollection('events');
    var listOfCourses = await userCollection.find().toList();
    List items = [];
    for (int i = 0; i < listOfCourses.length; i++) {
      var createdAt = listOfCourses[i]["createdAt"];
      var formatedDate;
        formatedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
        var courseCard = EventCard(
            listOfCourses[i]["theme"],
            listOfCourses[i]["photo"],
            listOfCourses[i]["date"].toString(),
            listOfCourses[i]["description"],
            listOfCourses[i]["participants"],
            listOfCourses[i]["title"],
            listOfCourses[i]["status"],
            listOfCourses[i]["_id"],
            );
        items.add(courseCard);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getListAskedCourses(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Center(
                  // child: Text(args.toString())
                  child: Column(children: <Widget>[
                    snapshot.data![index],
                  ]),
                );
              });
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            ),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }
}
