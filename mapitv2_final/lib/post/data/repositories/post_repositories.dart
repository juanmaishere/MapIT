// Extracción de datos de la BD
import 'package:map_it/post/data/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostRepository {
  //Llamada a la api con http para que traiga un post de un usuario
  Future<List<PostModel>> getUserPost(String userId) async {
    final http.Response response = await http.get(Uri.parse(
      'https://mapit-kezkcv4lwa-ue.a.run.app/get_places?user_id=$userId'));
      if (response.statusCode >= 200 && response.statusCode <= 205) {
      // Si el servidor devuelve una respuesta OK, parseamos el JSON
      List<dynamic> resData = jsonDecode(response.body);
      return resData
          .map((e) => PostModel(
              postId: e['places_id'].toString(),
              title: e['post_title'].toString(),
              lat: double.parse(e['latitud']),
              lng: double.parse(e['longitude']),
              content: e['post_text'],
              createdAt: DateTime.now().toString(),
              userId: e['user_id'],
              image: e['url_post_photo']))
          .toList();
    } else {
      
      // Si la respuesta no es OK, lanzamos un error
      throw Exception('Failed to load data');
    }
  }

  Future<bool> UserPostToDb(PostModel newPost) async {
    String jsonpost = jsonEncode(newPost.toJson());
    print(newPost);
    print(jsonpost);
    print(jsonpost.runtimeType);
    final http.Response response = await http.post(
      Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/add_places'),
      headers: {'Content-Type': 'application/json'},
      body: jsonpost,
    );
    if (response.statusCode >= 200 && response.statusCode <= 205) {
      print('PLACE AÑADIDO');
      return true;
    } else {
      print("ERROR AL AÑADIR PLACE");
      print(response.body);
      print(response.statusCode);
      return false;
    }
  }
}
