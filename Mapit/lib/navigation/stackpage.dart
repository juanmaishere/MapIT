import 'package:map_it/authentication/data/models/user_model.dart';

import '../location/presentation/screens/map_screen.dart';
import '../settings/presentation/settingspage.dart';
import '../friends/presentation/friends_page.dart';
import 'package:flutter/material.dart';
import '../authentication/data/repositories/auth_repository.dart';

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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "MapIT",
              style: TextStyle(fontFamily: 'DonGraffiti', color: Colors.white),
            ),
            Text(
              "${currentUser.name}",
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
            ),
            ClipOval(
                child: Image.asset(
              "lib/assets/AlexMarcelli.jpg",
              width: 70,
              height: 67,
            )),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 2, 25, 48),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedLabelStyle:
            const TextStyle(color: Color.fromARGB(230, 217, 56, 110)),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        selectedItemColor: const Color.fromARGB(255, 252, 252, 252),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 2, 25, 34),
        items: <BottomNavigationBarItem>[
           BottomNavigationBarItem(
            icon: Image.asset('lib/assets/friend.png', width: 50, height: 50,),
            activeIcon: Image.asset('lib/assets/friends.png', width: 50, height: 50,),
            label: 'Friends',
            backgroundColor: Color.fromARGB(255, 24, 18, 20),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/inactivemap.png',
              width: 50,
              height: 50,
            ),
            activeIcon: Image.asset(
              'lib/assets/activemap.png',
              width: 50,
              height: 50,
            ),
            label: 'Map',
            backgroundColor: Color.fromARGB(255, 19, 9, 14),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 35,
            ),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 88, 219, 210),
          ),
        ],
      ),
    );
  }
}
