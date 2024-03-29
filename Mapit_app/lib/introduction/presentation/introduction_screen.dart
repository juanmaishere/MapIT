import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:map_it/introduction/presentation/circle_avatar.dart';
import 'package:map_it/location/presentation/screens/camera.dart';
import 'package:map_it/navigation/stackpage.dart';

class IntroductionScreens extends StatefulWidget {
  @override
  _IntroductionScreensState createState() => _IntroductionScreensState();
}

class _IntroductionScreensState extends State<IntroductionScreens> {
  Uint8List selectImage = Uint8List(0);
  bool isImageSelected = false;
  var auth = AuthRepository();
  String message = """
Elije tu foto favorita de la galeria o toma una y cuentale a tus amigos porque deberian visitar el lugar o simplemente cuenta tu experiencia


Hay marcadores de todo tipo
- Markers por 24 Horas
- Markers Privado
- Markers Publicos y mas
""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Antes de iniciar elige una foto de perfil',
              bodyWidget: CustomCircleAvatar(
                onTap: () async {
                  File? selectedImage =
                      await ImagePickerHelper.pickImageFromGallery();
                  if (selectedImage != null) {
                    Uint8List imageBytes = selectedImage.readAsBytesSync();
                    setState(() {
                      selectImage = imageBytes;
                      isImageSelected = true;
                      auth.updateProfileUser(selectedImage);
                    });
                  }
                },
              ),
              image: isImageSelected
                  ? CircleAvatar(
                      radius: 100,
                      child: Image.memory(
                        selectImage,
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                      ))
                  : CircleAvatar(
                      radius: 100,
                      child: Image.network(
                        'https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=',
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      )),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Como usar MapIT?',
              body:
                  'MapIT te permite añadir puntos en el mapa para compartir con tus amigos en cualquier parte del mundo y en el momento que quieras',
              image: buildImage("lib/assets/newmapactive.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Añade puntos al mapa con el boton MapIT',
              body: message,
              image: buildImage("lib/assets/markers.png"),

              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Añade amigos',
              body: 'Añade amigos para compartir tus puntos y ver los de ellos',
              image: buildImage("lib/assets/friendactive.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Disfruta de MapIT',
              body:
                  'Ahora simplemente disfruta de explorar y recorrer las experiencias y historias a lo largo del mapa',
              image: buildImage("lib/assets/mapit.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
          ],
          onDone: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Stackpage()),
              (route) => false,
            );
          },
          freeze: true,
          showSkipButton: false,
          showNextButton: isImageSelected ? true : false,
          next: const Icon(Icons.forward),
          done:
              const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
          dotsDecorator: getDotsDecorator()),
    );
  }

  //widget to add the image on screen
  Widget buildImage(String imagePath) {
    return Center(
        child: Image.asset(
      imagePath,
      width: 450,
      height: 200,
    ));
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120, bottom: 20),
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 15),
      titlePadding: EdgeInsets.only(top: 50, bottom: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Color.fromARGB(255, 240, 65, 65),
      color: Colors.grey,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
