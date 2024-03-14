// Extracción de datos de la BD
import 'package:map_it/post/data/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class PostRepository {
  //Llamada a la api con http para que traiga un post de un usuario
  Future<List<PostModel>?> getUserPost(String userId) async {
    final http.Response response = await http
        .get(Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/places/$userId'));
    if (response.statusCode >= 200 && response.statusCode <= 205) {
      // Si el servidor devuelve una respuesta OK, parseamos el JSON

      List<dynamic> resData = jsonDecode(response.body);
      return resData
          .map((e) => PostModel(
              postId: e['places_id'].toString(),
              title: e['post_title'],
              lat: double.parse(e['latitud']),
              lng: double.parse(e['longitude']),
              content: e['post_text'],
              createdAt: DateTime.now().toString(),
              userId: e['user_id'],
              image: e['url_post_photo']))
          .toList();
    } else {
      // Si la respuesta no es OK, lanzamos un error
      return null;
    }
  }

  Future<bool> UserPostToDb(PostModel newPost) async {
    String jsonPost = jsonEncode(newPost.toJson());
    final http.Response response = await http.post(
      Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/places'),
      headers: {'Content-Type': 'application/json'},
      body: jsonPost,
    );
    if (response.statusCode >= 200 && response.statusCode <= 205) {
      print('PLACE AÑADIDO');
      return true;
    } else {
      print("ERROR AL AÑADIR PLACE");
      return false;
    }
  }

  Future<bool> deletePostDb(PostModel post) async {
    String jsonPost = jsonEncode(post.toJson());
    final http.Response response = await http.delete(
      Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/places'),
      headers: {'Content-Type': 'application/json'},
      body: jsonPost,
    );

    if (response.statusCode >= 200 && response.statusCode <= 205) {
      print('PLACE ELIMINADO');
      return true;
    } else {
      print("ERROR AL ELIMINAR   PLACE");
      return false;
    }
  }

  Future<String?> uploadImage(File imageFile, String userId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      Reference ref =
          storage.ref().child(userId).child(basename(imageFile.path));
      await ref.putFile(imageFile);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error al subir la imagen: $e');
      return null;
    }
  }
}
