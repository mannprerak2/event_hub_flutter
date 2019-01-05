import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:events_flutter/models/login_states.dart';

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
  //this emits streams of type loginstate, so we can manage UI accordingly
  Stream<LoginState> initFbLogin() async* {
    print("initFbLogin");
    yield LoginInProgress();

    var facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.loginWithPublishPermissions(['manage_pages']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        print(facebookLoginResult.errorMessage);
        yield LoginError(facebookLoginResult.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        yield LoginCancelled();
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        facebookAccessToken = facebookLoginResult.accessToken;
        yield LoginSuccess();
        break;
    }
  }
}

class Result {}
