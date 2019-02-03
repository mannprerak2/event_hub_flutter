import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/resources/saved_provider.dart';
import 'package:sqflite/sqflite.dart';

// Handles all the sqlite operations
// Used for
// 1. offline caching shown until app is making request
//    which will be deleted on the first event get request after app opens
//    and refilled with new cache
// 2. For saved events, which will be completely stored in this database

class SQLite {
  String dbPath;
  SavedEventProvider provider;

  void saveEvent(DocumentSnapshot snapshot) async {
    provider ??= SavedEventProvider();
    dbPath ??= await getDatabasesPath() + "saved.db";
    await provider.open(dbPath);

    provider.insert(snapshot);
  }

  void removeEvent(DocumentSnapshot snapshot) async {
    provider ??= SavedEventProvider();
    dbPath ??= await getDatabasesPath() + "saved.db";
    await provider.open(dbPath);

    provider.delete(snapshot.documentID);
  }

  Future<bool> hasEvent(String id) async {
    provider ??= SavedEventProvider();
    dbPath ??= await getDatabasesPath() + "saved.db";
    await provider.open(dbPath);

    return await provider.exists(id);
  }

  // void getAllSavedEventIds(GlobalBloc globalBloc) async {
  //   provider ??= SavedEventProvider();
  //   dbPath ??= await getDatabasesPath() + "saved.db";
  //   await provider.open(dbPath);

  //   List<String> list = await provider.getAllIds();
  //   globalBloc.savedEvents.clear();
  //   globalBloc.savedEvents.addAll(list);
  // }

  Future<List<Map<String, dynamic>>> getSavedEvents(
      int batchSize, int page) async {
    provider ??= SavedEventProvider();
    dbPath ??= await getDatabasesPath() + "saved.db";
    await provider.open(dbPath);

    List<Map<String, dynamic>> list = await provider.getEvents(batchSize, page);
    return list;
  }
}
