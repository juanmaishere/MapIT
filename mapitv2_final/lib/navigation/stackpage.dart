import '../location/presentation/screens/map_screen.dart';
import '../settings/presentation/settingspage.dart';
import '../friends/presentation/friends_page.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Stackpage extends StatefulWidget {
  @override
  _Stack createState() => _Stack();
}

class _Stack extends State<Stackpage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MapScreen(),
    const Friendsscreen(),
    const SettingWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MapIt'),
        backgroundColor: Color.fromARGB(230, 217, 56, 110),
        titleTextStyle: TextStyle(color: Colors.black), // Corrected line
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
            const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        selectedItemColor: Color.fromARGB(255, 252, 252, 252),
        unselectedItemColor: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/inactivemap.png', width: 45, height: 45),
            activeIcon: Image.asset('assets/activemap.png'),
            label: 'Map',
            backgroundColor: Color.fromARGB(255, 221, 93, 136),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/31.png', width: 45, height: 45),
            activeIcon: Image.asset('assets/32.png'),
            label: 'Friends',
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