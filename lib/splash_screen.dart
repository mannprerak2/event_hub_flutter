import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/states/hub_states.dart';
import 'package:events_flutter/states/splash_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatelessWidget {
  /// When this turns "2", we push the main screen.
  static var animationAndLoginSync = 0;

  /// Only pushes main screen if [animationAndLoginSync] is 2.
  void canPushMainScreen(GlobalBloc globalBloc) {
    animationAndLoginSync++;
    if (animationAndLoginSync >= 2) {
      globalBloc.hubStateStreamController.add(ShowMainState());
      animationAndLoginSync = 0;
    }
  }

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
                text: [
                  "EventHub",
                ],
                isRepeatingAnimation: false,
                onFinished: () => canPushMainScreen(globalBloc),
                textStyle: TextStyle(
                    fontSize: 45.0, fontFamily: "Agne", color: Colors.white),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpinKitFadingCube(
                color: Colors.white,
                size: 50.0,
              ),
            ),
            StreamBuilder(
              stream: globalBloc.splashStateStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data is LoginInProgress) {
                  } else if (snapshot.data is LoginSuccess) {
                    //show mainscreen here
                    canPushMainScreen(globalBloc);
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
