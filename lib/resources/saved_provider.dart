import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
// not to be used directly, will be used from sqlite_db

final String tableName = 'saved_events';
final String columnId = 'id';
final String columnName = 'name';
final String columnImage = 'image';
final String columnDate = 'date';
final String columnLocation = 'location';

// get method returns a document snapshot with no ID as its only setter..
// id is set as a field in snapshot.data only
class SavedEventProvider {
  Database db;

  Future open(String path) async {
    if (db == null || !db.isOpen) {
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableName ( 
  $columnId text primary key, 
  $columnName text not null,
  $columnImage text not null,
  $columnLocation text not null,
  $columnDate text not null)
''');
      });
    }
  }

  Future<bool> exists(String id) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return true;
    }
    return false;
  }

  void insert(DocumentSnapshot snapshot) async {
    Map<String, dynamic> map = Map();
    map['id'] = snapshot.documentID;
    map['name'] = snapshot.data['name'];
    map['location'] = snapshot.data['location'];
    map['image'] = snapshot.data['image'];
    map['date'] = snapshot.data['date'].toString();
    await db.insert(tableName, map,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<Map<String, dynamic>> getEvent(String id) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
          columnName,
          columnImage,
          columnDate,
          columnLocation
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      Map<String, dynamic> snapshot = Map();
      maps.first.forEach((key, object) {
        if (object == 'date')
          snapshot[key] = DateTime.parse(object);
        else
          snapshot[key] = object;
      });
      return snapshot;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getEvents(int batchSize, int page) async {
    List<Map<String, dynamic>> list = [];
    List<Map> map = await db.query(
      tableName,
      columns: [columnId, columnName, columnDate, columnImage, columnLocation],
      limit: batchSize,
      offset: page * batchSize,
      orderBy: "$columnDate ASC",
    );
    map.forEach((imap) {
      Map<String, dynamic> snapshot = Map();
      imap.forEach((key, object) {
        if (key == 'date')
          snapshot[key] = DateTime.parse(object);
        else {
          snapshot[key] = object;
        }
      });
      list.add(snapshot);
    });

    return list;
  }

  void delete(String id) async {
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<String>> getAllIds() async {
    List<String> list = [];
    List<Map> map = await db.query(
      tableName,
      columns: [columnId],
    );
    print("map: " + map.toString());
    map.forEach((imap) {
      imap.forEach((key, object) {
        list.add(object);
      });
    });

    return list;
  }

  Future close() async => db.close();
}
