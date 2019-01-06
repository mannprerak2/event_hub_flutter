import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// states for managing the splash screen state, used as if-elseif.... 
// in streambuilder in splash_Screen.dart

class SplashState {}

// for token
class TokenState extends SplashState {}

class TokenExpired extends TokenState {}

class TokenNotFound extends TokenState {}

class TokenValid extends TokenState {
  FacebookAccessToken facebookAccessToken;
  TokenValid(this.facebookAccessToken);
}

//for login
class LoginState extends SplashState {}

class LoginInProgress extends LoginState {}

class LoginError extends LoginState {
  String error;
  LoginError(this.error);
}

class LoginCancelled extends LoginState {}

class LoginSuccess extends LoginState {}
