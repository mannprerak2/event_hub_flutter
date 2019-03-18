import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/main_screen.dart';
import 'package:events_flutter/states/hub_states.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  void initState() {
    Firestore.instance
        .settings(persistenceEnabled: true, timestampsInSnapshotsEnabled: true);
    // try login to firebase on app start
    globalBloc.firebase.firebaseLogin(globalBloc);

    // add subscriptions to list
    globalBloc.sqlite.getAllSubsNames(globalBloc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalProvider(
      globalBloc: globalBloc,
      child: MaterialApp(
        title: 'EventsFlutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.red, primaryColor: Color(0xffB54646)),
        home: StreamBuilder(
          // HUB state builder
          stream: globalBloc.hubStateStreamController.stream,
          initialData: ShowSplashState(),
          builder: (context, snapshot) {
            if (snapshot.data is ShowSplashState) {
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
