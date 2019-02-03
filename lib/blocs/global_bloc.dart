import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/resources/firebase.dart';
import 'package:events_flutter/resources/shared_prefs.dart';
import 'package:events_flutter/resources/sqlite_db.dart';
import 'package:events_flutter/states/hub_states.dart';
import 'package:events_flutter/states/splash_states.dart';
import 'package:events_flutter/states/main_states.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

// all streamcontrollers are 'sinks' to which network or i/o service add data to
// widgets listen to these streamcontrollers ONLY

// Root level bloc, can be accessed from anywhere using GlobalProvider

class GlobalBloc {
  final MFirebase firebase = MFirebase();

  // for controlling the Root view state of app used (main.dart), e.g splash screen or mainscreen etc...
  final StreamController<HubState> hubStateStreamController =
      StreamController<HubState>();

  // for controlling the view states in splash screen
  final StreamController<SplashState> splashStateStreamController =
      StreamController<SplashState>();

  // for controlling the view states in main screen
  final StreamController<MainState> mainStateStreamController =
      StreamController<MainState>();

  // create sinks(Streamcontrollers) here to store data..
  // create streams from these sinks, for ui to listen to
  // fetch data from network and add it to respective sinks

  final List<DocumentSnapshot> eventListCache = [];
  final List<DocumentSnapshot> eventPageCache = [];

  FirebaseUser user;
  // final List<String> savedEvents = [];
  final SharedPrefs sharedPrefs = SharedPrefs();
  final SQLite sqlite = SQLite();

  //call this from main.dart to dispose off sinks
  void dispose() {
    hubStateStreamController.close();
    mainStateStreamController.close();
    sqlite.provider.close();
  }

  void disposeSplashController() {
    splashStateStreamController.close();
  }
}
