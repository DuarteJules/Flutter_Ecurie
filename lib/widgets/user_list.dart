import 'package:flutter/material.dart';

import '../providers/mongodb.dart';
import 'package:intl/intl.dart';

import 'user_card.dart';


var mongodb = DBConnection.getInstance();
class UserList extends StatefulWidget {
  const UserList({ Key? key }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  Future<List> getListUSer() async {
    var userCollection = mongodb.getCollection('users');
    var listOfUser = await userCollection.find().toList();
    List items = [];
    for (int i = 0; i < listOfUser.length; i++) {
      var createdAt = listOfUser[i]["createdAt"];
      var formattedDate;
      if (createdAt != null) {
        formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
        var userCard = UserCard(
            listOfUser[i]["username"], listOfUser[i]["mail"], formattedDate, listOfUser[i]["image"]);
        items.add(userCard);
      } else {
        var userCard =
            UserCard(listOfUser[i]["username"], listOfUser[i]["mail"], "null", listOfUser[i]["image"]);
        items.add(userCard);
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