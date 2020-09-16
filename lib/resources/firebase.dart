import './../blocs/global_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:events_flutter/states/splash_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MFirebase {
  MFirebase();

  void firebaseLogin(GlobalBloc globalBloc) async {
    print("initFbLogin");
    globalBloc.splashStateStreamController.add(LoginInProgress());
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
    try {
      globalBloc.user = (await FirebaseAuth.instance.signInAnonymously()).user;
      globalBloc.splashStateStreamController.add(LoginSuccess());
    } catch (e) {
      print(e.toString());
      globalBloc.splashStateStreamController.add(LoginError(e.toString()));
    }
  }
}
