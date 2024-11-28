part of 'authentication_bloc.dart';

sealed class AuthEvent {}

class AuthLoginRequest extends AuthEvent {
  final String username;
  final String password;
  AuthLoginRequest(this.username, this.password);
}

class AuthRegisterRequest extends AuthEvent {
  final String username;
  final String password;
  final String passwordConfirm;
  AuthRegisterRequest(this.username, this.password, this.passwordConfirm);
}
