import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/data/repositories/post_repositories.dart';
import 'package:permission_handler/permission_handler.dart';

class FormModalWidget extends StatefulWidget {
  PostModel? post;
  final UserModel user;
  final Position? position;
  final LocationBloc bloc;
  FormModalWidget(
      {required this.post,
      required this.user,
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
  bool _isPrivate = false;
  bool _is24hsMode = false;
  @override
  Widget build(BuildContext context) {
    PostModel? post = widget.post;
    final UserModel user = widget.user;
    final Position? position = widget.position;
    final LocationBloc bloc = widget.bloc;
    if (post != null) {
      if (user.id == post.userId) {
        _titleController.text = post.title ?? '';
        _contentController.text = post.content ?? '';
        _isPrivate = post.private;
      } else {
        _titleController.text = '';
        _contentController.text = '';
      }
    }
    return OverflowBox(
      minWidth: 0.0,
      minHeight: 0.0,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
      child: Align(
        alignment: AlignmentDirectional(0, 0),
        child: Card(
          color: const Color(0xFFF3F3F0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Add a Title',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            PopupMenuButton<int>(
                              color: const Color(0xFFF3F3F0),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_isPrivate ? 'Privado' : 'Público'),
                                      Icon(_isPrivate
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('24hs Mode'),
                                      Icon(_is24hsMode ? Icons.done : null),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 1) {
                                  _isPrivate = !_isPrivate;
                                } else if (value == 2) {
                                  _is24hsMode = !_is24hsMode;
                                }
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showImageSourceModal(context);
                        },
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            image: _selectedImage != null
                                ? DecorationImage(
                                    image: MemoryImage(
                                        Uint8List.fromList(_selectedImage!)),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                        'https://cdn.pixabay.com/photo/2021/07/25/08/07/add-6491203_1280.png'),
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight:
                                  100), // Ajusta la altura máxima como necesites
                          child: Scrollbar(
                            radius: const Radius.circular(10),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  controller: _contentController,
                                  maxLength: 250,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    hintText: 'Add Content',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Radio de las esquinas
                    color: Colors
                        .transparent, // Color transparente para que el Divider sea visible
                  ),
                  child: Divider(
                    color: Colors.black, // Color de la línea
                    thickness: 0.5, // Grosor de la línea
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 4, 2, 17),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color.fromARGB(255, 4, 2, 17),
                            ),
                            onPressed: () async {
                              post = post ??
                                  PostModel(
                                    userId: user.id,
                                    postId:
                                        '${user.id}/${position!.latitude}-${position.longitude}',
                                    lat: position.latitude,
                                    lng: position.longitude,
                                    createdAt: DateTime.now().toString(),
                                  );
                              Navigator.of(context).pop();
                              bool saved = await _savePost(post!, user.id);
                              if (saved)
                                bloc.add(AddPlace(
                                    position: position!,
                                    userId: user.id,
                                    post: post!));
                            },
                            child: Text(
                              'Post',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )),
                      ]),
                ),
              ]),
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

  Future _pickImageFromCamera() async {
    // Check if camera permission is granted
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
      // Request camera permission
      await Permission.camera.request();
      // Check the status again after the user has responded to the permission request
      cameraStatus = await Permission.camera.status;
    }

    if (cameraStatus.isGranted) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile == null) return;

      setState(() {
        selectedIMage = File(pickedFile.path);
        _selectedImage = File(pickedFile.path).readAsBytesSync();
      });
    } else {
      // Handle the case where the user denied camera permission
      // You might want to show a message or take appropriate action
      print('Camera permission denied');
    }
  }

  Future _showImageSourceModal(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
