import 'package:flutter/material.dart';
import '../../widgets/friendsrow_model.dart';
import '../../widgets/widget_add_friends.dart';

class Friendsscreen extends StatefulWidget {
  const Friendsscreen({Key? key}) : super(key: key);

  @override
  _Friendwidget createState() => _Friendwidget();
}

class _Friendwidget extends State<Friendsscreen> {
  bool? switchValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, -1),
                      child: Text(
                        'My Friends',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 3.25,
                indent: 75,
                endIndent: 75,
                color: Colors.black, // Change to your desired color
              ),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: AlignmentDirectional(-0.9, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 10, 0, 0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: const FriendsrowWidget(
                                  name:
                                      "Teo"), // Include your FriendsrowWidget here
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: const FriendsrowWidget(
                                  name:
                                      "Sebita"), // Include your FriendsrowWidget here
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              const Divider(
                thickness: 3,
                indent: 75,
                endIndent: 75,
                color: Colors.black, // Change to your desired color
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 35.5, 0, 7.5),
                child: ElevatedButton(
                  onPressed: () async {
                    showTextAlertDialog(context);
                  },
                  child: Text(
                    'Add Friend',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 64, 184, 240), // Change to your desired color
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 105, 35, 0),
                  child: const FriendsrowWidget(name: "User")),
            ],
          ),
        ),
      ),
    );
  }
}
