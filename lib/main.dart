import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventsFlutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'EventFlutter'),
    );
  }
}

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

  void onLoginStatusChanged(bool isLoggedIn, int loginStatus) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.loginStatus = loginStatus;
    });
  }

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
      if(s!=null)
        picUrls.add(s);
    }
    print(picUrls);
    setPicUrls(picUrls);
  }

  void loginFb() async {
    var facebookLogin = FacebookLogin();
    facebookLoginResult =
        await facebookLogin.loginWithPublishPermissions(['manage_pages']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false, 1);

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false, 2);

        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        onLoginStatusChanged(true, 0);

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
          Container(child: isLoggedIn ? buildAfterLogin() : buildBeforeLogin()),
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

  Center buildBeforeLogin() {
    return Center(
      child: RaisedButton(
        onPressed: loginFb,
        color: Colors.blue,
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
