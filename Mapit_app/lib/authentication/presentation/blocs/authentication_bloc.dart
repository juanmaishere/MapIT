import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepo})
      : _authRepository = authRepo,
        super(authRepo.currentUser!.isNotEmpty
            ? AuthSuccess(user: authRepo.currentUser!)
            : const AuthState.unInitialized()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
  }
  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.authLoading());
    try {
      final email = event.email;
      final password = event.password;
      final user =
          await _authRepository.logIn(email: email, password: password);
      emit(user != null && user.isNotEmpty
          ? AuthSuccess(user: user)
          : const AuthFailure(errorMessage: 'Invalid email or password!'));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    unawaited(_authRepository.logOut());
  }

  void _onAuthSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.authLoading());
    try {
      final username = event.name;
      final email = event.email;
      final password = event.password;
      if (username.isEmpty) {
        emit(
          const AuthFailure(errorMessage: 'Username cannot be empty!'),
        );
        return;
      } else if (username.length < 6) {
        emit(
          const AuthFailure(
              errorMessage: 'Username cannot be less than 6 characters!'),
        );
        return;
      }
      if (await _authRepository.getUserByName(username) != null) {
        emit(
          const AuthFailure(errorMessage: 'Username already exists!'),
        );
        return;
      }
      if (email.isEmpty || !email.contains('@')) {
        emit(
          const AuthFailure(errorMessage: 'Invalid email address!'),
        );
        return;
      }
      if (password.length < 6) {
        emit(
          const AuthFailure(
              errorMessage: 'Password cannot be less than 6 characters!'),
        );
        return;
      }
      final user = await _authRepository.signUp(
          name: username, email: email, password: password);
      if (user != null && user.isNotEmpty) emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}
