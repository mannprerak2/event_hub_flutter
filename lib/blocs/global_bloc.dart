import 'dart:async';
import 'package:events_flutter/models/hub_states.dart';
import 'package:events_flutter/models/splash_states.dart';
import 'package:events_flutter/models/main_states.dart';
import 'package:rxdart/rxdart.dart';
import './../resources/facebook_api.dart';

// all streamcontrollers are 'sinks' to which network or i/o service add data to
// widgets listen to these streamcontrollers ONLY

// Root level bloc, can be accessed from anywhere using GlobalProvider

class GlobalBloc{
  final FacebookAPI facebookAPI = FacebookAPI();
  
  // for controlling the Root view state of app used (main.dart), e.g splash screen or mainscreen etc...
  final StreamController<HubState> hubStateStreamController = StreamController<HubState>();

  // for controlling the view states in splash screen
  final StreamController<SplashState> splashStateStreamController = StreamController<SplashState>();

  // for controlling the view states in main screen
  final StreamController<MainState> mainStateStreamController = StreamController<MainState>();
  int currentMainTab = 0;
  // create sinks(Streamcontrollers) here to store data..
  // create streams from these sinks, for ui to listen to
  // fetch data from network and add it to respective sinks





  //call this from main.dart to dispose off sinks
  void dispose(){
    hubStateStreamController.close();
    mainStateStreamController.close();
  }
  void disposeSplashController(){
    splashStateStreamController.close();
  }
}