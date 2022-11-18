import 'package:flutter/material.dart';
import 'package:flutter_ecurie/widgets/courses_card.dart';

import '../providers/mongodb.dart';
import 'package:intl/intl.dart';

import 'contest_card.dart';
import 'user_card.dart';

var mongodb = DBConnection.getInstance();

class AskedContestList extends StatefulWidget {
  const AskedContestList({Key? key}) : super(key: key);

  @override
  _AskedCoursesListState createState() => _AskedCoursesListState();
}

class _AskedCoursesListState extends State<AskedContestList> {
  Future<List> getListAskedCourses() async {
    var userCollection = mongodb.getCollection('contest');
    var listOfContests = await userCollection.find().toList();
    List items = [];
    for (int i = 0; i < listOfContests.length; i++) {
      var createdAt = listOfContests[i]["createdAt"];
      var formatedDate;
      formatedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
      var contestCard = ContestCard(
        listOfContests[i]["title"],
        listOfContests[i]["description"],
        listOfContests[i]["date"].toString(),
        listOfContests[i]["adress"],
        listOfContests[i]["photo"],
        listOfContests[i]["participants"],
        listOfContests[i]["status"],
        listOfContests[i]["_id"],
      );
      items.add(contestCard);
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
