import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:map_it/authentication/data/models/user_model.dart';

Future<void> sendUserData(String userId, String name) async {
  final response = await http.post(
    Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userid': userId,
      'username': name,
    }),
  );
  if (response.statusCode == 200) {
    print('User data sent successfully');
  } else {
    throw Exception('Failed to send user data');
    print(response);
  }
}

Future<void> sendProfilePhoto(userid, username, userimage) async {
  print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  print(userimage);
  final response = await http.put(
    Uri.parse('https://mapit-kezkcv4lwa-ue.a.run.app/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userid': userid,
      'username': username,
      'userimage': userimage,
    }),
  );
  if (response.statusCode == 200) {
    print('User data sent successfully');
  } else {
    throw Exception('Failed to send user data');
    print(response);
  }
}
