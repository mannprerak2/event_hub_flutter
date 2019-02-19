import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/states/hub_states.dart';
import 'package:events_flutter/states/splash_states.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalProvider.of(context);

    return Scaffold(
      backgroundColor: Color(0xffB54646),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "EventHub",
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          CircularProgressIndicator(),
          StreamBuilder(
            stream: globalBloc.splashStateStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data is LoginInProgress) {
                  return Text("Please wait...");
                } else if (snapshot.data is LoginSuccess) {
                  //show mainscreen here
                  globalBloc.hubStateStreamController.add(ShowMainState());
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
        globalBloc.firebase.firebaseLogin(globalBloc);
      },
      child: Text("Retry"),
    );
  }
}
