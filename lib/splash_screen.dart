import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/models/hub_states.dart';
import 'package:events_flutter/models/splash_states.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalProvider.of(context);

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
          StreamBuilder(
            stream: globalBloc.splashStateStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //for token states
                if (snapshot.data is TokenExpired ||
                    snapshot.data is TokenNotFound) {
                  return loginButton(globalBloc);
                } else if (snapshot.data is TokenValid) {
                  //show mainscreen here
                  globalBloc.hubStateStreamController.add(ShowMainState());
                } else if (snapshot.data is LoginInProgress) {
                  return Text("Please wait...");
                } else if (snapshot.data is LoginSuccess) {
                  //show mainscreen here
                  globalBloc.hubStateStreamController.add(ShowMainState());
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
                }
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  RaisedButton loginButton(GlobalBloc globalBloc) {
    return RaisedButton(
      onPressed: () {
        globalBloc.facebookAPI.initFbLogin(globalBloc);
      },
      child: Text("Login"),
    );
  }
}
