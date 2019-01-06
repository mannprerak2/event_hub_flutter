import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:events_flutter/resources/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:events_flutter/models/splash_states.dart';
import './../blocs/global_bloc.dart';

// the only class which handles all facebook api network related stuff 
// and then adds them to sinks in globalBloc for the other widgets to listen to

class FacebookAPI {
  final String baseUrl;
  final Map<String, Result> cache;
  final http.Client client;

  FacebookAPI(
      {HttpClient client,
      Map<String, Result> cache,
      this.baseUrl = "https://graph.facebook.com/v3.2/"})
      : this.client = client ?? http.Client(),
        this.cache = cache ?? <String, Result>{};

  FacebookAccessToken facebookAccessToken;

  //put async functions here

  //Login Facebook
  void initFbLogin(GlobalBloc globalBloc) async {
    print("initFbLogin");
    globalBloc.splashStateStreamController.add(LoginInProgress());

    var facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.loginWithPublishPermissions(['manage_pages']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        print(facebookLoginResult.errorMessage);
        globalBloc.splashStateStreamController
            .add(LoginError(facebookLoginResult.errorMessage));
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        globalBloc.splashStateStreamController.add(LoginCancelled());
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        facebookAccessToken = facebookLoginResult.accessToken;
        //save token to sharedprefs
        SharedPrefs().saveToken(facebookAccessToken.toMap());
        globalBloc.splashStateStreamController.add(LoginSuccess());
        break;
    }
  }
}

class Result {}
