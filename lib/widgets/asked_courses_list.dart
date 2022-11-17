import 'package:flutter/material.dart';
import 'package:flutter_ecurie/widgets/courses_card.dart';

import '../providers/mongodb.dart';
import 'package:intl/intl.dart';

import 'user_card.dart';

var mongodb = DBConnection.getInstance();

class AskedCoursesList extends StatefulWidget {
  const AskedCoursesList({Key? key}) : super(key: key);

  @override
  _AskedCoursesListState createState() => _AskedCoursesListState();
}

class _AskedCoursesListState extends State<AskedCoursesList> {
  Future<List> getListAskedCourses() async {
    var userCollection = mongodb.getCollection('courses');
    var listOfCourses = await userCollection.find().toList();
    List items = [];
    for (int i = 0; i < listOfCourses.length; i++) {
      var createdAt = listOfCourses[i]["createdAt"];
      var formatedDate;
      if (createdAt != null) {
        formatedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
        var courseCard = CoursesCard(
            listOfCourses[i]["title"],
            listOfCourses[i]["description"],
            listOfCourses[i]["date"],
            listOfCourses[i]["hour"],
            listOfCourses[i]["duration"],
            listOfCourses[i]["discipline"],
            listOfCourses[i]["place"],
            formatedDate,
            listOfCourses[i]["_id"],
            listOfCourses[i]["status"]);
        items.add(courseCard);
      } else {
        var courseCard = CoursesCard(
            listOfCourses[i]["title"],
            listOfCourses[i]["description"],
            listOfCourses[i]["date"],
            listOfCourses[i]["hour"],
            listOfCourses[i]["duration"],
            listOfCourses[i]["discipline"],
            listOfCourses[i]["place"],
            "null",
            listOfCourses[i]["_id"],
            listOfCourses[i]["status"],);
        items.add(courseCard);
      }
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
