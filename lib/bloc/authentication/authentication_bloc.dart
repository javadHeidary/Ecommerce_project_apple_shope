import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shop/data/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthenticationRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthenInitial()) {
    on<AuthRegisterRequest>(
      (event, emit) => _loadRegisterRequest(
        event.username,
        event.password,
        event.passwordConfirm,
        emit,
      ),
    );
    on<AuthLoginRequest>(
      (event, emit) => _loadLoginRequest(
        event.username,
        event.password,
        emit,
      ),
    );
  }

  Future<void> _loadRegisterRequest(String username, String password,
      String passwordConfirm, Emitter<AuthState> emit) async {
    emit(
      AuthLoading(),
    );
    final Either<String, String> registerResponse =
        await _authRepository.register(
      username,
      password,
      passwordConfirm,
    );
    emit(
      AuthResponse(registerResponse),
    );
  }

  Future<void> _loadLoginRequest(
      String username, String password, Emitter<AuthState> emit) async {
    emit(
      AuthLoading(),
    );
    final Either<String, String> loginResponse = await _authRepository.login(
      username,
      password,
    );
    emit(
      AuthResponse(loginResponse),
    );
  }
}
