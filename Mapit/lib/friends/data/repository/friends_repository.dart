import 'dart:convert';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;

class FriendshipRepository {
  String currentUserId = AuthRepository().getCurrentUser().id;
  List<UserModel>? userFriends = [];
  // Future<void> getUserFriends(String userId) async {
  //   userFriends = await llamadaAPI();
  // }
  Future<List<UserModel>>? getUserFriends() async {
    final response = await http.get(Uri.parse(
        'https://mapit-kezkcv4lwa-ue.a.run.app/friends/$currentUserId'));

    if (response.statusCode >= 200 && response.statusCode <= 205) {
      List<dynamic>? resData = jsonDecode(response.body);
      print(resData);
      if (resData != null) {
        List<UserModel> friends = resData
            .map((e) =>
                UserModel(id: e['user2_id'] ?? '', name: e['username'] ?? ''))
            .toList();

        return friends;
      } else {
        throw Exception('Response data is null');
      }
    } else {
      throw Exception('Failed to load friends');
    }
  }

  Future<bool> addFriend(String userId) async {
    final response = await http.post(
      Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/add_friend'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id1': currentUserId,
        'user_id2': userId,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode <= 205) {
      print('Solicitud exitosa, respuesta: ${response.body}');
      return true;
    } else {
      print('Solicitud fallida con código de estado: ${response.statusCode}');
      return false;
    }
  }

  Future<bool> deleteFriend(String userId) async {
    final response = await http.post(
      Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/delete_friend'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id1': currentUserId,
        'user_id2': userId,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode <= 205) {
      print('Solicitud exitosa, respuesta: ${response.body}');
      return true;
    } else {
      print('Solicitud fallida con código de estado: ${response.statusCode}');
      return false;
    }
  }
}
