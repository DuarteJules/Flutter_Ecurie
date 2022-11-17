import '../providers/mongodb.dart';


var mongodb = DBConnection.getInstance();
var collection = mongodb.getCollection('feedActuality');

class Newsfeed{

  insertNews(String data, String label){
    var timestamp = DateTime.now();
    collection.insertOne({
      'description' : data,
      'label' : label,
      'createdAt' : timestamp
    });
  }
}
