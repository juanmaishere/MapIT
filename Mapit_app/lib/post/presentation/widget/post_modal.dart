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
  final LocationBloc? bloc;
  PostModel post;
  PostModal({
    required this.title,
    required this.user,
    required this.post,
    required this.owner,
    this.bloc,
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
                          backgroundImage: NetworkImage(
                              'https://media.istockphoto.com/id/1397756029/es/foto/gato-de-bengala-en-gafas-trabaja-en-la-mesa-en-la-computadora.jpg?s=1024x1024&w=is&k=20&c=P8sGBWf5Mqq65n2z03ajz6zHlorZePQo3_lgpmoVruc=')),
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
                                "@${user.name!}",
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
                                      userId: user.id,
                                      bloc: bloc!,
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
                                        _deletePost(post);
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
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              height: 150, // Set a fixed height for the text section
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                child: ExpandableText(
                  post.content!,
                  expandText: 'show more',
                  collapseText: 'show less',
                  maxLines: 2,
                  linkColor: Color.fromARGB(255, 35, 215, 247),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _deletePost(PostModel post) {}
}
