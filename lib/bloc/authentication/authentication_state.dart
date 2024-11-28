part of 'authentication_bloc.dart';

sealed class AuthState {}

final class AuthenInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthResponse extends AuthState {
  final Either<String, String> response;

  AuthResponse(this.response);
}
