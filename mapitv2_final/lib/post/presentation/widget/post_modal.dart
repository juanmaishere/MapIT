import 'package:flutter/material.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/presentation/widget/post_form.dart';

class PostModal extends StatelessWidget {
  final String title;
  final String userId;
  final String? content;
  final LocationBloc? bloc;
  PostModel post;
  PostModal({super.key, 
    required this.title,
    required this.userId,
    required this.post,
    this.bloc,
    this.content,
  });


  @override
  Widget build(context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(110, 0, 0, 0),
          ),
          child: Container(
            padding: EdgeInsets.all(15.0),
            color: Color.fromARGB(244, 255, 255, 255),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Row
                
                if (userId == post.userId)
              Row(children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return FormModalWidget(
                          post: post,
                          userId: userId,
                          bloc: bloc!,
                        );
                      },
                    );
                  },
                ),
                  GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Borrar Posteo'),
                            content: Text('¿Estás seguro de borrar este posteo?'),
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
                                //  _deletePost(post);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
              ]),
                
                
                
                
                


                SizedBox(height: 30),
                // Separate Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
                // Added spacing
                SizedBox(height: 30),
                // Image
                Image.asset(
                  'assets/AlexMarcelli.jpg',
                  height: 225.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                SizedBox(height: 30),
                // Content Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    content ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 30.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "This was posted by @Zovko",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
