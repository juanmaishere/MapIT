import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

export 'friendsrow_model.dart';

class FriendsrowWidget extends StatelessWidget {
  final String name;
  const FriendsrowWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          child: Container(
            width: 45,
            height: 45,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.network(
              'https://picsum.photos/seed/486/600',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 1,
                children: [
                  SlidableAction(
                    label: 'Close',
                    backgroundColor: Color.fromARGB(226, 255, 83, 83),
                    icon: Icons.close,
                    foregroundColor: Colors.black,
                    onPressed: (_) {
                      print('SlidableActionWidget pressed ...');
                    },
                  ),
                  SlidableAction(
                    label: 'Share',
                    backgroundColor: Color.fromARGB(210, 0, 0, 0),
                    icon: Icons.share,
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    onPressed: (_) {
                      print('SlidableActionWidget pressed ...');
                    },
                  ),
                  SlidableAction(
                    label: 'Delete',
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    icon: Icons.delete,
                    foregroundColor: Color.fromARGB(255, 0, 0, 0),
                    onPressed: (_) {
                      print('SlidableActionWidget pressed ...');
                    },
                  ),
                ],
              ),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.userFriends,
                ),
                title: Text(name,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                tileColor: Colors.white,
                dense: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}