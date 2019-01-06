import 'dart:convert';

import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/models/splash_states.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

// the only class the handle all sharedpref logic
// and then adds them to sinks in globalBloc for other widgets to listen too

class SharedPrefs {
  Future<void> saveToken(Map<String, dynamic> map) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("token", json.encode(map));
    print("saving token");
  }

  void getToken(GlobalBloc globalBloc) async {
    print("Ran GetToken");
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (sp.getString("token") != null) {
      Map<String, dynamic> map = json.decode(sp.getString("token"));
      FacebookAccessToken facebookAccessToken =
          FacebookAccessToken.fromMap(map);
      //check validity
      //checking if token validity has atleast 1-2 days
      if (facebookAccessToken.expires.isAfter(DateTime.now()) &&
          facebookAccessToken.expires.day > DateTime.now().day - 1) {
        print("Token Valid");
        globalBloc.splashStateStreamController.add(TokenValid(facebookAccessToken));
      } else {
        print("Token expired");
        sp.remove("token");
        globalBloc.splashStateStreamController.add(TokenExpired());
      }
    } else {
      print("Token not found");
      globalBloc.splashStateStreamController.add(TokenNotFound());
    }
  }
}
