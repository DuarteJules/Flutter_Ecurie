import 'package:flutter/material.dart';
import 'package:flutter_ecurie/widgets/news_card.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart;

import '../providers/mongodb.dart';
import 'package:intl/intl.dart';


var mongodb = DBConnection.getInstance();

class NewsCardList extends StatefulWidget{
  const NewsCardList({ Key? key }) : super(key: key);

  @override
  _NewsCardListState createState() => _NewsCardListState();
}

class _NewsCardListState extends State<NewsCardList>{

  Future<List> getNewsFiltered() async {
    var newsCollection = mongodb.getCollection('feedActuality');
    var listNewsCards = await newsCollection.find(dart.where.sortBy('createdAt', descending: true)).toList();
    List resultList = [];

    for (int i = 0; i < listNewsCards.length; i++){
      var createdAt = listNewsCards[i]["createdAt"];
      var formattedDate;

      formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
      var card = NewsCard(listNewsCards[i]['description'], listNewsCards[i]['label'], formattedDate);
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
