class LoginState {
  
}

class LoginReady extends LoginState{

}

class LoginInProgress extends LoginState{

}

class LoginError extends LoginState{
  String error;
  LoginError(this.error);
}

class LoginCancelled extends LoginState{

}

class LoginSuccess extends LoginState{

}