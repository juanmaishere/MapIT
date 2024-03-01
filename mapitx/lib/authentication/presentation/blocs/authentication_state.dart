part of 'authentication_bloc.dart';

enum AuthStatus { unInitialized, authSuccess, authFailure, authLoading }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;

  /*
    Constructor Privado: 
    Se asegura que los usuarios de la clase AuthState no puedan crear instancias
    de AuthState directamente con cualquier estado o usuario.

    Se utiliza para definir la lógica común de construcción que es compartida por
    los constructores públicos.

    Si no se proporciona un estado, se utilizará AuthStatus.unknown por defecto.
    Los constructores con nombre son útiles cuando una clase necesita más de un constructor.
  */
  const AuthState._({
    this.status = AuthStatus.unInitialized,
    this.user,
  });

  /*
  Constructor Público con nombre:
  Crea una instancia de AuthState en el estado unInitialized y el usuario null.
  No acepta ningún argumento y llama al constructor privado sin pasar ningún parámetro.
  */
  const AuthState.unInitialized() : this._();


  /* 
  Constructor Público con nombre:
  Crea una instancia de AuthState en el estado authenticated. Acepta un user como
  argumento y llama al constructor privado pasando AuthStatus.authenticated como
  status y el user proporcionado.
  */
  
  /*
  Constructor Público con nombre:
  Crea una instancia de AuthState en el estado loading y el usuario null.
  */
  const AuthState.authLoading() : this._(status: AuthStatus.authLoading);

  @override
  List<Object?> get props => [status, user];
}

class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure({required this.errorMessage}) : 
    super._(status: AuthStatus.authFailure);
  
  @override
  List<Object?> get props => [status, errorMessage];
}

final class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess({required this.user}) : super._(
    status: AuthStatus.authSuccess,
    user: user,
  );
  
  @override
  List<Object?> get props => [status];
}
