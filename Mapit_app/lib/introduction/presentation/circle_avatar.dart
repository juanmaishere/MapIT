import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final VoidCallback onTap;

  CustomCircleAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 30, // Set your desired radius
        backgroundColor: Color.fromARGB(255, 0, 0, 0), // Set your desired background color
        child: Icon(
          Icons.person,
          color: Colors.white, // Set your desired icon color
        ),
      ),
    );
  }
}