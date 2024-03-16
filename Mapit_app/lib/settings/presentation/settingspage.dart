import 'package:flutter/material.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:map_it/authentication/presentation/screens/log_in_screen.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({Key? key}) : super(key: key);
  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final AuthRepository _authRepository = AuthRepository();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: GlobalKey<ScaffoldState>(),
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 25, 0, 0),
                child: Text(
                  'Settings Page',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Color(0xFF15161E),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildListTile(context, 'About Us'),
              _buildListTile(context, 'Third Party Software'),
              _buildListTile(context, 'Terms and Conditions'),
              _buildListTile(context, 'Change Log'),
              _buildListTile(context, 'Privacy Policy'),
              _buildListTile(context, 'Help'),
              _buildListTile(context, 'Log Out', onTap: _logOut),
              Spacer(),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Text(
                  'App Versions',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Color(0xFF15161E),
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                child: Text(
                  'v0.0.1',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Color(0xFF606A85),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logOut() async {
    await _authRepository.logOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  Widget _buildListTile(BuildContext context, String title,
      {VoidCallback? onTap}) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: Icon(
        Icons.read_more,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
