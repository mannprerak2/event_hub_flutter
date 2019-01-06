import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/main_screen.dart';
import 'package:events_flutter/models/hub_states.dart';
import 'package:events_flutter/resources/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// App is implemented using BLoC pattern..
// we have only one GlobalBloc for now.. wrapped with GlobalProvider
// which is an inherited widget, made the root of the app (in build method of MyAppState)
// you can get reference of Global bloc as following (anywhere as its the root)
// globalBloc = GlobalProvider.of(context)
//
// MyApp is stateful because we need to override 'dispose' plus greater flexibility for future
//
// all the network stuff is handled in facebook_api.dart

void main() => runApp(MyApp());

//root widget of app
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final GlobalBloc globalBloc = GlobalBloc();

  @override
  Widget build(BuildContext context) {
    return GlobalProvider(
      globalBloc: globalBloc,
      child: MaterialApp(
        title: 'EventsFlutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder( // HUB state builder
          stream: globalBloc.hubStateStreamController.stream,
          initialData: ShowSplashState(),
          builder: (context, snapshot) {
            //sometimes the process will be so fast that splashscreen may not even be shown
            //if we need to slow it down.. we must use a timer before we call SharedPrefs.getToken
            if (snapshot.data is ShowSplashState) {
              SharedPrefs().getToken(globalBloc);
              return SplashScreen();
            } else if (snapshot.data is ShowMainState) {
              globalBloc.disposeSplashController();
              return MainScreen();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    //dispose all sinks of global block here
    globalBloc.dispose();
    super.dispose();
  }
}

// =========================OLD CONTENT BELOW THIS, WILL BE DELETED============

class Post {}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String fbapi = "https://graph.facebook.com/v3.2/";
  final List<String> pageIds = ["458226214198430"];

  List<String> postIds = [];
  List<String> picUrls = [];
  FacebookLoginResult facebookLoginResult;
  bool isLoggedIn = false;
  int loginStatus = -1;

  void setPostIds(List<String> postIds) {
    setState(() {
      this.postIds = postIds;
    });
  }

  void setPicUrls(List<String> picUrls) {
    setState(() {
      this.picUrls = picUrls;
    });
  }

  void fetchPostIds() async {
    List<String> postIds = [];
    List<String> picUrls = [];
    http.Response response = await http.get(fbapi +
        "${pageIds[0]}" +
        "/posts?fields=id"
        "&access_token=${facebookLoginResult.accessToken.token}");
    var dataObj = json.decode(response.body)["data"];
    for (var obj in dataObj) {
      postIds.add(obj["id"]);
    }
    setPostIds(postIds);
    for (int i = 0; i < postIds.length; i++) {
      http.Response response2 = await http.get(fbapi +
          "${postIds[i]}" +
          "?fields=full_picture" +
          "&access_token=${facebookLoginResult.accessToken.token}");
      var s = json.decode(response2.body)["full_picture"];
      print(json.decode(response2.body));
      if (s != null) picUrls.add(s);
    }
    print(picUrls);
    setPicUrls(picUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: fetchPostIds,
              child: Text("Fetch"),
            )
          : null,
    );
  }

  Padding buildAfterLogin() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: ListView.builder(
        itemCount: picUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Image.network(picUrls[index]),
          );
        },
      )),
    );
  }
}
