import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './../resources/facebook_api.dart';

class GlobalBloc{
  final FacebookAPI facebookAPI = FacebookAPI();
  
  Stream loginStream;
  
  // create sinks here to store data..
  // create streams from these sinks, for ui to listen to
  // fetch data from network and add it to respective sinks





  //call this from main.dart to dispose off sinks
  void dispose(){

  }
}