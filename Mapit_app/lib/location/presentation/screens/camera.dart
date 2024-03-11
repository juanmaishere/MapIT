import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHelper {
  static Future<File?> pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    return returnImage != null ? File(returnImage.path) : null;
  }

  static Future<File?> pickImageFromCamera() async {
    // Check if camera permission is granted
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
      // Request camera permission
      await Permission.camera.request();
      // Check the status again after the user has responded to the permission request
      cameraStatus = await Permission.camera.status;
    }

    if (cameraStatus.isGranted) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      return pickedFile != null ? File(pickedFile.path) : null;
    } else {
      // Handle the case where the user denied camera permission
      // You might want to show a message or take appropriate action
      print('Camera permission denied');
      return null;
    }
  }
}