// Interfaz del repositorio de autenticación
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:http/http.dart' as http;
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/post/data/repositories/post_repositories.dart';
import 'saveusertosql.dart';

class AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  final repo = PostRepository();
  AuthRepository({fb.FirebaseAuth? fbAuth})
      : _firebaseAuth = fbAuth ?? fb.FirebaseAuth.instance;
  /*
  Escuchar los cambios en el estado de autenticación (inicio de sesión o cierre de sesión).
  El método map() transforma los eventos de cambio de estado en objetos User.
  Si no hay un usuario autenticado, se devuelve un User.empty.
  */
  var currentUser = UserModel.empty;
  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
      currentUser = user;
      return user;
    });
  }

  UserModel getCurrentUser() {
    return AuthRepository()._firebaseAuth.currentUser!.toUser;
  }

 Completer<void> _updateProfileCompleter = Completer<void>();

void updateProfileUser(image) async {
  try {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      var photo = await repo.uploadImage(image, currentUser.id);
      await user.updatePhotoURL(photo);
      await user.reload();
      _updateProfileCompleter.complete(); // Terminamos d subir la imagen
    }
  } catch (e) {
    // Handle exceptions
    print("Error updating profile picture: $e");
    _updateProfileCompleter.completeError(e); // Signal error
  }
}

Future<String> getUserProfilePic() async {
  await _updateProfileCompleter.future; // Esperamos que termine de subir la iamgen
  final user = _firebaseAuth.currentUser;
  if (user != null) {
    return user.photoURL!;
  } else {
    return 'lib/assets/user.png';
  }
}

  /*
  Crea un nuevo usuario con el correo electrónico y la contraseña proporcionados 
  y devuelve el usuario creado con el método nativo de FirebaseAuth o null
  en caso de error.
  */
  Future<UserModel?> signUp(
      {required String email, required String password, name}) async {
    try {
      final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final fireBaseUser = credentials.user;
      if (fireBaseUser != null) {
        await fireBaseUser.updateDisplayName(name);
        await fireBaseUser.reload();
      }
      sendUserData(fireBaseUser!.uid, name);
      final newUser = UserModel(
        /*! en Dart se llama “postfix not null assertion”.
        Se utiliza para decirle al analizador de Dart que la expresión que precede no será null.
        */
        id: fireBaseUser!
            .uid, //significa que estás seguro de que fireBaseUser no será null cuando se acceda a su propiedad uid. Si fireBaseUser fuera null, se lanzaría un error en tiempo de ejecución
        email: fireBaseUser.email,
        name: name,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );
      return newUser;
    } on fb.FirebaseAuthException catch (e) {
      //Manejar excepciones
      return null;
    }
  }

  /*Función de logeo */
  Future<UserModel?> logIn(
      {required String email, required String password}) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final fireBaseUser = credentials.user;
      //Buscar en la Base de datos el usuario exacto y devolverlo.
      final user = UserModel(id: fireBaseUser!.uid);
      return user;
    } on fb.FirebaseAuthException catch (e) {
      //Manejar excepciones
      return null;
    }
  }

  /*cerrar la sesión */
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      //Manejo de exepciones
    }
  }

  Future<UserModel?> getUserByName(String userName) async {
    try {
      final http.Response response = await http.get(Uri.parse(
          'https://mapit-kezkcv4lwa-ue.a.run.app/search_user/$userName'));
      if (response.statusCode >= 200 && response.statusCode <= 205) {
        final resData = jsonDecode(response.body);
        final user =
            UserModel(id: resData['userid'], name: resData['username']);
        return user;
      } else {
        return null;
      }
    } on fb.FirebaseAuthException catch (e) {
      //Manejar excepciones
      return null;
    }
  }
}

extension on fb.User {
  UserModel get toUser {
    return UserModel(
        id: uid,
        email: email,
        name: displayName,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString());
  }

// ignore: unused_element
}
