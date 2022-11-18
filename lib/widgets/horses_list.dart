import 'package:flutter/material.dart';

import '../providers/mongodb.dart';
import 'package:intl/intl.dart';

import 'horses_card.dart';
import 'user_card.dart';

var mongodb = DBConnection.getInstance();

class HosrsesList extends StatefulWidget {
  const HosrsesList({Key? key}) : super(key: key);

  @override
  _HosrsesListState createState() => _HosrsesListState();
}

class _HosrsesListState extends State<HosrsesList> {
  Future<List> getListUSer() async {
    var horseCollection = mongodb.getCollection('horses');
    var listOfHorses = await horseCollection.find().toList();
    List items = [];
    for (int i = 0; i < listOfHorses.length; i++) {
      var createdAt = listOfHorses[i]["createdAt"];
      var formattedDate;
      if (createdAt != null) {
        formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
        var horseCard = HorsesCard(listOfHorses[i]["name"],
            listOfHorses[i]["breed"], listOfHorses[i]["year"], formattedDate);
        items.add(horseCard);
      } else {
        var horseCard = HorsesCard(listOfHorses[i]["name"],
            listOfHorses[i]["breed"], listOfHorses[i]["year"], formattedDate);
        items.add(horseCard);
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getListUSer(),
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
