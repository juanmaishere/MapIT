
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionScreens extends StatelessWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Como usar MapIT?',
              body: 'MapIT te permite añadir puntos en el mapa para compartir con tus amigos en cualquier parte del mundo y en el momento que quieras',
              image: buildImage("assets/mapit.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Añade puntos al mapa con el boton MapIT',
              body: 'Elije tu foto favorita de la galeria o toma una y cuentale a tus amigos porque deberian visitar el lugar o simplemente cuenta tu experiencia',
              image: buildImage("images/newmapactive.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Añade amigos',
              body: 'Añade amigos para compartir tus puntos y ver los de ellos',
              image: buildImage("images/friendactive.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Disfruta de MapIT',
              body: 'Ahora simplemente disfruta de explorar y recorrer las experiencias y historias a lo largo del mapa',
              image: buildImage("images/mapit.png"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
          ],
          onDone: () {
          Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => IntroductionScreens()),
                (route) => false,
              );          },
          onSkip:() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => IntroductionScreens()),
                (route) => false,
              );   
          },
          //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
          scrollPhysics: const ClampingScrollPhysics(),
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: true,
          skip:
              const Text("Skip", style: TextStyle(fontWeight: FontWeight.w600)),
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
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
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