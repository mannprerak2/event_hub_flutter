// states for managing the splash screen state, used as if-elseif.... 
// in streambuilder in splash_Screen.dart

class SplashState {}
//for login
class LoginState extends SplashState {}

class LoginInProgress extends LoginState {}

class LoginError extends LoginState {
  String error;
  LoginError(this.error);
}

class LoginSuccess extends LoginState {}
