import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/location/presentation/screens/camera.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/presentation/widget/post_form.dart';
import 'package:map_it/post/presentation/widget/post_modal.dart';
import '../../../assets/mapstyles.dart';
import '../../../widgets/maptype_widget.dart';
import '../../../authentication/data/repositories/auth_repository.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);
  final UserModel currentUser = AuthRepository().getCurrentUser();
  final repo = AuthRepository();
  var _mapController;

  bool namecolor = false;
  bool userbool = false;
  File? _selectedImage;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LocationLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  buildingsEnabled: false,
                  trafficEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(mapStyle2);
                    _mapController = controller; // Save the controller instance
                    context.read<LocationBloc>().add(
                        LoadMap(controller: controller, user: currentUser));
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        state.position.latitude, state.position.longitude),
                    zoom: 15,
                  ),
                  markers: generateMarkersFromMap(
                      state.places ?? {}, context, state, currentUser),
                ),
                Positioned(
                  bottom: 30.0,
                  right: 20.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext contextDialog) {
                          return FormModalWidget(
                              post: null,
                              user: currentUser,
                              position: position,
                              bloc: BlocProvider.of<LocationBloc>(context));
                        },
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 2, 25, 34),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder<String>(
                            future: repo.getUserProfilePic(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // Handle error case
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final photoURL = snapshot.data;

                                return CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 233, 233),
                                  backgroundImage: NetworkImage(photoURL ??
                                      'lib/assets/user.png'),
                                );
                              }
                            },
                          ),
                          Container(
                            child: Text(
                              "${currentUser.name}",
                              style: TextStyle(
                                  color: namecolor
                                      ? Color.fromARGB(255, 0, 0, 0)
                                      : const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w500),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 9),
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: namecolor
                                    ? Color.fromARGB(255, 1, 14, 19)
                                    : Color.fromARGB(95, 255, 255, 255),
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                          ),
                        ])),
                Positioned(
                  top: 50.0, // Adjust the top position as needed
                  right: 10.0, // Adjust the right position as needed
                  child: SlidingButtonWidget(onTapCallback: () {
                    _mapController?.setMapStyle(mapStyle3);
                    namecolor =
                        true; // Reload the map when the map style changes
                  }, onTapCallback2: () {
                    _mapController?.setMapStyle(mapStyle2);
                    namecolor = false;
                  }, onTapCallback3: () {
                    _mapController?.setMapStyle(mapStyle1);
                    namecolor = false;
                  }),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

Set<Marker> generateMarkersFromMap(Map<String, PostModel> postsMap,
    BuildContext context, LocationLoaded state, UserModel currentUser) {
  Set<Marker> markers = {};
  postsMap.forEach((postId, post) {
    BitmapDescriptor icon;

    if (post.private == true) {
      icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    } else if (post.private == false) {
      icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    } else if (post.image == null) {
      icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    } else {
      icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    }
    final Marker marker = Marker(
      icon: icon,
      markerId: MarkerId(postId),
      position: LatLng(post.lat, post.lng),
      onTap: () {
        // Lógica para manejar el tap en el marcador
        final owner = (state.friends != null && state.friends!.isNotEmpty)
            ? state.friends!.firstWhere(
                (u) => u.id == post.userId,
                orElse: () => currentUser,
              )
            : currentUser;
        showDialog(
          context: context,
          builder: (BuildContext contextDialog) {
            return PostModal(
              title: post.title,
              content: post.content,
              user: currentUser,
              owner: owner,
              post: post,
              bloc: BlocProvider.of<LocationBloc>(context),
            );
          },
        );
      },
    );
    markers.add(marker);
  });

  return markers;
}
