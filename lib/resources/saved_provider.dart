import 'package:sqflite/sqflite.dart';
// not to be used directly, will be used from sqlite_db

final String tableName = 'saved_events';
final String columnId = 'id';
final String columnName = 'name';
final String columnImage = 'image';
final String columnDate = 'date';
final String columnSocietyName = 'society';
final String columnLocation = 'location';
final String columnCollege = 'college';

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
  $columnSocietyName text not null,
  $columnImage text not null,
  $columnLocation text not null,
  $columnCollege text not null,
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

  void insert(Map<String, dynamic> snapshot) async {
    Map<String, dynamic> map = Map();
    map['date'] = snapshot['date'].toString();
    map['id'] =snapshot['id'];
    map['name'] = snapshot['name'];
    map['image'] = snapshot['image'];
    map['location'] = snapshot['location'];
    map['college'] = snapshot['college'];
    map['society'] = snapshot['society'];

    await db.insert(tableName, map,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<Map<String, dynamic>> getEvent(String id) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
          columnName,
          columnSocietyName,
          columnImage,
          columnDate,
          columnLocation,
          columnCollege
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
      columns: [
        columnId,
        columnName,
        columnSocietyName,
        columnDate,
        columnImage,
        columnLocation,
        columnCollege
      ],
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

  Future close() async => db.close();
}
