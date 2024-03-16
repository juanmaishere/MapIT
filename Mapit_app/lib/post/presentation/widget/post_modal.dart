import 'package:flutter/material.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/presentation/widget/post_form.dart';
import 'package:expandable_text/expandable_text.dart';

class PostModal extends StatelessWidget {
  final String? title;
  final UserModel user;
  final UserModel owner;
  final String? content;
  final LocationBloc bloc;
  PostModel post;
  PostModal({
    required this.title,
    required this.user,
    required this.post,
    required this.owner,
    required this.bloc,
    this.content,
  });
  @override
  Widget build(context) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Card(
          child: Container(
        // Adjust padding
        width: MediaQuery.of(context).size.width, // Adjust width
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3), // White color with 90% opacity
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(owner.userImage ??
                              'https://www.svgrepo.com/show/60463/add-user.svg')),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title!,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 1),
                              Text(
                                "@${owner.name}",
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w200),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  if (user.id == owner.id)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 7.5, 0),
                            child: GestureDetector(
                              child: Icon(Icons.edit),
                              onTap: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return FormModalWidget(
                                      post: post,
                                      user: user,
                                      bloc: bloc,
                                    );
                                  },
                                );
                              },
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          child: Icon(Icons.delete),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Borrar Posteo'),
                                  content: Text(
                                      '¿Estás seguro de borrar este posteo?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Aceptar'),
                                      onPressed: () {
                                        bloc.add(DeletePlace(post: post));
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Image.network(
              post.image!,
              width: MediaQuery.sizeOf(context).width,
              height: 350,
              fit: BoxFit.cover,
              alignment: Alignment(0, 0),
            ),
            Container(
              margin: EdgeInsets.all(7),
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 150), // Ajusta la altura máxima como necesites
                child: Scrollbar(
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ExpandableText(
                        post.content!,
                        expandText: 'Show more',
                        collapseText: 'Show less',
                        expandOnTextTap: true,
                        maxLines: 5,
                        linkColor: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
