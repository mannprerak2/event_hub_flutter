import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/models/login_states.dart';
import 'package:flutter/material.dart';

import './resources/facebook_api.dart';


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  Stream loginStream = null;

  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalProvider.of(context);
    //get loginStream
    // loginStream = globalBloc.facebookAPI.initFbLogin();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Text(
              "EventHub",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<LoginState>(
            stream: loginStream,
            initialData: LoginReady(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data is LoginInProgress) {
                  return Text("Please wait...");
                } else if (snapshot.data is LoginSuccess) {
                  return Text("Success");
                } else if (snapshot.data is LoginCancelled) {
                  return Column(
                    children: <Widget>[
                      Text("Login was cancelled by user"),
                      loginButton(globalBloc)
                    ],
                  );
                } else if (snapshot.data is LoginError) {
                  return Column(
                    children: <Widget>[
                      Text((snapshot.data as LoginError).error),
                      loginButton(globalBloc)
                    ],
                  );
                } else if (snapshot.data is LoginReady) {
                  return loginButton(globalBloc);
                }
              }
              // runs the first time..
              return Text("...");
            },
          )
        ],
      ),
    );
  }

  RaisedButton loginButton(GlobalBloc globalBloc) {
    return RaisedButton(
                  onPressed: () {
                    setState(() {
                      loginStream = globalBloc.facebookAPI.initFbLogin();
                    });
                  },
                  child: Text("Login"),
                );
  }
}
