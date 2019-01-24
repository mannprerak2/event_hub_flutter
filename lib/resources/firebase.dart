import './../blocs/global_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:events_flutter/states/splash_states.dart';

class MFirebase {
  MFirebase();


  void firebaseLogin(GlobalBloc globalBloc) async {
    print("initFbLogin");
    globalBloc.splashStateStreamController.add(LoginInProgress());

    try{
      globalBloc.user = await FirebaseAuth.instance.signInAnonymously();
      globalBloc.splashStateStreamController.add(LoginSuccess());
    }
    catch(e){
      print(e.toString());
      globalBloc.splashStateStreamController.add(LoginError(e.toString()));
    }
    
  }
}
