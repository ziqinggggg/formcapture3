import 'package:formcapture/imports.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventSignUp extends AuthEvent {
  final String email;
  final String password;
  final String username;
  const AuthEventSignUp(this.email, this.password, this.username);
}

class AuthEventShouldSignUp extends AuthEvent {
  const AuthEventShouldSignUp();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventSignOut extends AuthEvent {
  const AuthEventSignOut();
}
