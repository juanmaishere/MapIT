import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/data/repositories/post_repositories.dart';

class FormModalWidget extends StatefulWidget {
  PostModel? post;
  final String userId;
  final Position? position;
  final LocationBloc bloc;
  FormModalWidget(
      {required this.post,
      required this.userId,
      required this.bloc,
      this.position});
  @override
  _FormModalWidgetState createState() => _FormModalWidgetState();
}

class _FormModalWidgetState extends State<FormModalWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Uint8List? _selectedImage;
  File? selectedIMage;
  bool _isPrivate = true;
  @override
  Widget build(BuildContext context) {
    PostModel? post = widget.post;
    final String userId = widget.userId;
    final Position? position = widget.position;
    final LocationBloc bloc = widget.bloc;
    if (post != null) {
      if (userId == post.userId) {
        _titleController.text = post.title ?? '';
        _contentController.text = post.content ?? '';
        _isPrivate = post.private ?? true;
      } else {
        _titleController.text = '';
        _contentController.text = '';
        _isPrivate = true;
      }
    }
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                _pickImageFromGallery();
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: _selectedImage != null
                      ? DecorationImage(
                          image:
                              MemoryImage(Uint8List.fromList(_selectedImage!)),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _contentController,
                maxLength: 250,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Private Post'),
              value: _isPrivate,
              onChanged: (value) {
                setState(() {
                  _isPrivate = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    post = post ??
                        PostModel(
                          userId: userId,
                          postId:
                              '$userId/${position!.latitude}-${position.longitude}',
                          lat: position.latitude,
                          lng: position.longitude,
                          createdAt: DateTime.now().toString(),
                        );
                    Navigator.of(context).pop();
                    bool saved = await _savePost(post!, userId);
                    if (saved)
                      bloc.add(AddPlace(position: position!, userId: userId, post: post!));
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _savePost(PostModel post, String userId) async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final bool isPrivate = _isPrivate;
    post.image = await PostRepository().uploadImage(selectedIMage!, userId);
    if (post.image == null) return false;
    post.title = title;
    post.content = content;
    post.private = isPrivate;
    return true;
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _selectedImage = File(returnImage.path).readAsBytesSync();
    });
  }
}
