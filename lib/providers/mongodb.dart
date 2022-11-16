import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;

class DBConnection {
  static late DBConnection _instance;
  final String? _mongoUri = dotenv.env['MONGO_URI'];
  final String? _dbName = dotenv.env['DB_NAME'];
  static bool _isInstance = false;
  static bool _isInit = false;
  late Db _db;

  static DBConnection getInstance() {
    if(_isInstance) return DBConnection._instance;

    DBConnection._instance = DBConnection();
    DBConnection._isInstance = true;
    return DBConnection._instance;
  }

  Future<void> connect() async {
    if(_isInit == false) {
      _isInit = true;
      _db = Db(_getConnectionString());
      await _db.open();
    }
  }

  Future<Db> getConnection() async {
    return _db;
  }

  DbCollection getCollection(String collection) {
    return _db.collection(collection);
  }

  _getConnectionString() {
    return "$_mongoUri/$_dbName";
  }

  closeConnection() {
    _db.close();
  }
}