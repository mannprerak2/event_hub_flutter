import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/resources/saved_provider.dart';
import 'package:events_flutter/resources/subs_provider.dart';
import 'package:sqflite/sqflite.dart';

// Handles all the sqlite operations
// Used for
// 1. Saving bookmarks, subscriptions

class SQLite {
  String? eventsDbPath, subsDbPath;
  SavedEventProvider? eventsProvider;
  SubsProvider? subsProvider;
  // for bookmarks

  void saveEvent(Map<String, dynamic> snapshot) async {
    eventsProvider ??= SavedEventProvider();
    eventsDbPath ??= await getDatabasesPath() + "saved.db";
    await eventsProvider!.open(eventsDbPath);

    eventsProvider!.insert(snapshot);
  }

  void removeEvent(String? id) async {
    eventsProvider ??= SavedEventProvider();
    eventsDbPath ??= await getDatabasesPath() + "saved.db";
    await eventsProvider!.open(eventsDbPath);

    eventsProvider!.delete(id);
  }

  Future<bool> hasEvent(String? id) async {
    eventsProvider ??= SavedEventProvider();
    eventsDbPath ??= await getDatabasesPath() + "saved.db";
    await eventsProvider!.open(eventsDbPath);

    return await eventsProvider!.exists(id);
  }

  Future<List<Map<String, dynamic>>> getSavedEvents(
      int batchSize, int page) async {
    eventsProvider ??= SavedEventProvider();
    eventsDbPath ??= await getDatabasesPath() + "saved.db";
    await eventsProvider!.open(eventsDbPath);

    List<Map<String, dynamic>> list =
        await eventsProvider!.getEvents(batchSize, page);
    return list;
  }

  // for subscription data

  Future<List<Map<String, dynamic>>> getSubs(int batchSize, int page) async {
    subsProvider ??= SubsProvider();
    subsDbPath ??= await getDatabasesPath() + "subs.db";
    await subsProvider!.open(subsDbPath);

    List<Map<String, dynamic>> list =
        await subsProvider!.getSubs(batchSize, page);
    return list;
  }

  void getAllSubsNames(GlobalBloc globalbloc) async {
    subsProvider ??= SubsProvider();
    subsDbPath ??= await getDatabasesPath() + "subs.db";
    await subsProvider!.open(subsDbPath);

    List<String?> list = await subsProvider!.getAllNames();

    globalbloc.subsNameList.clear();
    globalbloc.subsNameList.addAll(list);
  }

  void saveSub(Map<String, dynamic> snapshot, GlobalBloc globalBloc) async {
    globalBloc.subsNameList.add(snapshot['name']);

    subsProvider ??= SubsProvider();
    subsDbPath ??= await getDatabasesPath() + "subs.db";
    await subsProvider!.open(subsDbPath);

    subsProvider!.insert(snapshot);
  }

  void removeSub(Map<String, dynamic> snapshot, GlobalBloc globalBloc) async {
    globalBloc.subsNameList.remove(snapshot['name']);

    subsProvider ??= SubsProvider();
    subsDbPath ??= await getDatabasesPath() + "subs.db";
    await subsProvider!.open(subsDbPath);

    subsProvider!.delete(snapshot['id']);
  }

  Future<bool> hasSub(String? id) async {
    subsProvider ??= SubsProvider();
    subsDbPath ??= await getDatabasesPath() + "subs.db";
    await subsProvider!.open(subsDbPath);

    return await subsProvider!.exists(id);
  }
}
