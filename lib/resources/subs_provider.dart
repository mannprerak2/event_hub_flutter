import 'package:sqflite/sqflite.dart';
// not to be used directly, will be used from sqlite_db

final String tableName = 'subscriptions';
final String columnId = 'id';
final String columnName = 'name';
final String columnDesc = 'desc';
final String columnImage = 'image';
final String columnCollege = 'college';

// get method returns a document snapshot with no ID as its only setter..
// id is set as a field in snapshot.data only
class SubsProvider {
  Database db;

  Future open(String path) async {
    if (db == null || !db.isOpen) {
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableName ( 
  $columnId text primary key,
  $columnName text not null,
  $columnDesc text not null,
  $columnImage text not null,
  $columnCollege text not null)
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
    Map<String, dynamic> map = Map.from(snapshot);
    await db.insert(tableName, map,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<Map<String, dynamic>> getSub(String id) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnId,
          columnName,
          columnDesc,
          columnImage,
          columnCollege,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      Map<String, dynamic> snapshot = Map();
      maps.first.forEach((key, object) {
        snapshot[key] = object;
      });
      return snapshot;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getSubs(int batchSize, int page) async {
    List<Map<String, dynamic>> list = [];
    List<Map> map = await db.query(
      tableName,
      columns: [columnId, columnName, columnDesc, columnImage, columnCollege],
      limit: batchSize,
      offset: page * batchSize,
      orderBy: "rowid DSC", // so that we get latest subscriptions first
    );
    map.forEach((imap) {
      Map<String, dynamic> snapshot = Map();
      imap.forEach((key, object) {
        snapshot[key] = object;
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
