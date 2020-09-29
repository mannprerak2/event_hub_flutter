import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/states/hub_states.dart';
import 'package:events_flutter/states/splash_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalProvider.of(context);

    return Scaffold(
      backgroundColor: Color(0xffB54646),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TyperAnimatedTextKit(
                speed: Duration(milliseconds: 100),
                pause: Duration(seconds: 3),
                text: [
                  "EventHub",
                ],
                textStyle: TextStyle(
                    fontSize: 45.0, fontFamily: "Agne", color: Colors.white),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                ),
            SizedBox(height: 30),
            StreamBuilder(
              stream: globalBloc.splashStateStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data is LoginInProgress) {
                    return SpinKitFadingCube(
                      color: Colors.white,
                      size: 50.0,
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
