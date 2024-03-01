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
    super(authRepo.currentUser.isNotEmpty
      ? AuthSuccess(user: authRepo.currentUser)
      : const AuthState.unInitialized()) 
    {
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

      if (password.length < 6) {
        return emit(
          AuthFailure(errorMessage: 'Password cannot be less than 6 characters!'),
        );
      }
      final user = await _authRepository.logIn(email: email, password: password);
      return emit(user != null && user.isNotEmpty
        ? AuthSuccess(user: user)
        : const AuthFailure(errorMessage: 'Error'),
      );
    } catch (e) {
      return emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  void _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    unawaited(_authRepository.logOut());
  }

  void _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit
    ) async {
    emit(AuthState.authLoading());
    try {
      final username = event.name;
      final email = event.email;
      final password = event.password;

      if (password.length < 6) {
        return emit(
          AuthFailure(errorMessage: 'Password cannot be less than 6 characters!'),
        );
      }
      final user = await _authRepository.signUp(
        name: username, 
        email: email, 
        password: password);
      return emit(user != null && user.isNotEmpty
        ? AuthSuccess(user: user)
        : const AuthFailure(errorMessage: 'Error'),
      );
    } catch (e) {
      return emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}
