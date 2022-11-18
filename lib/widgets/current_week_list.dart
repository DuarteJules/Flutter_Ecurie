import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ecurie/models/user_manager.dart';
import 'package:flutter_ecurie/services/current_week_feed.dart';
import 'package:flutter_ecurie/widgets/current_week_card.dart';
import 'package:flutter_ecurie/widgets/news_card.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;

import '../providers/mongodb.dart';
import 'package:intl/intl.dart';


var mongodb = DBConnection.getInstance();
var userUsername = UserManager.user.username;
bool userInParticipate = false;

class CurrentWeekCardList extends StatefulWidget{
  const CurrentWeekCardList({ Key? key }) : super(key: key);

  @override
  _CurrentWeekCardListState createState() => _CurrentWeekCardListState();
}

class _CurrentWeekCardListState extends State<CurrentWeekCardList>{

  // Function to add all events/contests/courses as formatted cards to display
  Future<List> getNewsFiltered() async {
    List resultList = [];
    var listNewsCardsCourses = await CurrentWeekFeed().getCourses();
    var listNewsCardsEvents = await CurrentWeekFeed().getEvents();
    var listNewsCardsContests = await CurrentWeekFeed().getContests();

    // loops through courses to create cards with retrieved data and adds them to returned List
    for (int i = 0; i < listNewsCardsCourses.length; i++){
      var createdAt = listNewsCardsCourses[i]["createdAt"];
      var date = listNewsCardsEvents[i]["date"];

      var formattedDateCreated = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
      var formattedDateDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
      if (listNewsCardsCourses[i]['participants'].length != 0) {
        userInParticipate = listNewsCardsCourses[i]['participants'].contains(userUsername);
      }

      var card = CurrentWeekCard('Cours', listNewsCardsCourses[i]['title'], listNewsCardsCourses[i]['description'], formattedDateCreated, formattedDateDate, userInParticipate);
      resultList.add(card);
    }

    // loops through events to create cards with retrieved data and adds them to returned List
    for (int i = 0; i < listNewsCardsEvents.length; i++){
      var createdAt = listNewsCardsEvents[i]["createdAt"];
      var date = listNewsCardsEvents[i]["date"];

      var formattedDateCreated = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
      var formattedDateDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
      if (listNewsCardsEvents[i]['participants'].length != 0) {
        userInParticipate = listNewsCardsEvents[i]['participants'].contains(userUsername);
      }

      var card = CurrentWeekCard("Évènement", listNewsCardsEvents[i]['title'], listNewsCardsEvents[i]['theme'], formattedDateCreated, formattedDateDate, userInParticipate);
      resultList.add(card);
    }

    // loops through contests to create cards with retrieved data and adds them to returned List
    for (int i = 0; i < listNewsCardsContests.length; i++){
      var createdAt = listNewsCardsContests[i]["createdAt"];
      var date = listNewsCardsContests[i]["date"];

      var formattedDateCreated = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
      var formattedDateDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
      for(int j = 0; j < listNewsCardsContests[i]['participants'].length; j++){
        if(listNewsCardsContests[i]['participants'][j]['username'] == userUsername){
          userInParticipate = true;
        }
      }

      var card = CurrentWeekCard('Concours', listNewsCardsContests[i]['title'], listNewsCardsContests[i]['description'], formattedDateCreated, formattedDateDate, userInParticipate);
      resultList.add(card);
    }

    return resultList;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getNewsFiltered(),
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
