import 'package:flutter/material.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/presentation/widget/post_form.dart';

class PostModal extends StatelessWidget {
  final String? title;
  final UserModel user;
  final String? content;
  final LocationBloc? bloc;
  PostModel post;
  PostModal({
    required this.title,
    required this.user,
    required this.post,
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
                              Text(
                                user.name!,
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  if (user.id == post.userId)
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
            ExpandableText(text: post.content!)
          ],
        ),
      )),
    );
  }

  void _deletePost(PostModel post) {}
}

class ExpandableText extends StatefulWidget {
  final String text;
  ExpandableText({required this.text});
  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            maxLines: _isExpanded ? 250 : null,
            overflow: TextOverflow.ellipsis,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Cambia el estado de expansión
              });
            },
            child: Opacity(
              opacity: 0.35,
              child: Text(
                _isExpanded
                    ? 'Mostrar menos'
                    : 'Mostrar más', // Cambia el texto del gatillo según el estado
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
