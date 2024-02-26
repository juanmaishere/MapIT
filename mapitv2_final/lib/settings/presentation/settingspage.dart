import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: GlobalKey<ScaffoldState>(),
          backgroundColor: Colors.white,
          body: Column(
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
              // Your list of settings here...
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
}