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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "EventHub",
              style: TextStyle(color: Colors.white, fontSize: 45),
            ),
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            StreamBuilder(
              stream: globalBloc.splashStateStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data is LoginInProgress) {
                    return Text(
                      "Please wait...",
                      style: TextStyle(color: Colors.white),
                    );
                  } else if (snapshot.data is LoginSuccess) {
                    //show mainscreen here
                    globalBloc.hubStateStreamController.add(ShowMainState());
                  } else if (snapshot.data is LoginError) {
                    return Column(
                      children: <Widget>[
                        Text(
                          "A network error has occured",
                          style: TextStyle(color: Colors.white),
                        ),
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
