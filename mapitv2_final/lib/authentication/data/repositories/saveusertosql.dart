import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
Future<void> sendUserData(String userId) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/usuarios'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'id': userId,
    }),
  );
  if (response.statusCode == 201) {
    print('User data sent successfully');
  } else {
    throw Exception('Failed to send user data');
  }
}
final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> getUserData() async {
  User? user = await FirebaseAuth.instance.authStateChanges().first;
  if (user != null) {
    print('User id: ' + user.uid);
    String? uid = user.uid;
    sendUserData(uid);
  }
}