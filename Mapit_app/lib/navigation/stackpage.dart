import 'package:map_it/authentication/data/models/user_model.dart';

import '../location/presentation/screens/map_screen.dart';
import '../settings/presentation/settingspage.dart';
import '../friends/presentation/friends_page.dart';
import 'package:flutter/material.dart';
import '../authentication/data/repositories/auth_repository.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// Other imports...

class Stackpage extends StatefulWidget {
  @override
  Stack createState() => Stack();
}

class Stack extends State<Stackpage> {
  int _currentIndex = 1;
  final UserModel currentUser = AuthRepository().getCurrentUser();
  final List<Widget> _pages = [
    FriendsScreen(),
    MapScreen(),
    const SettingWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        height: 55,
        items: <Widget>[
          Image.asset(
            'lib/assets/friendactive.png',
            width: 45,
            height: 45,
          ),
          Image.asset(
            'lib/assets/newmapactive.png',
            width: 55,
            height: 55,
          ),
          Icon(Icons.settings, size: 40, color: Color.fromARGB(255, 223, 232, 249),),
        ],
        color: Color.fromARGB(255, 2, 25, 34),
        buttonBackgroundColor: Color.fromARGB(142, 255, 255, 255),
        animationDuration: Duration(milliseconds: 350),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
      ),
    );
  }
}
