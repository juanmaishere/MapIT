import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/geolocation/data/geolocation_repository.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/data/repositories/post_repositories.dart';
import 'package:map_it/post/presentation/widget/post_form.dart';
import 'package:map_it/post/presentation/widget/post_modal.dart';
import '../../../assets/mapstyles.dart';
import '../../../widgets/maptype_widget.dart';
import '../../../authentication/data/repositories/auth_repository.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);
  final UserModel currentUser = AuthRepository().getCurrentUser();
  var _mapController;
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
                  Positioned(top: 30, right: 10,
              child: Text(
              "@${currentUser.name}",
              style:
                  TextStyle(fontWeight: FontWeight.w400, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            ),
                  GoogleMap(
                    myLocationEnabled: true,
                    buildingsEnabled: false,
                    trafficEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(mapStyle2);
                      _mapController = controller; // Save the controller instance
                      context.read<LocationBloc>().add(LoadMap(
                          controller: controller, user: currentUser));
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          state.position.latitude, state.position.longitude),
                      zoom: 15,
                    ),
                    markers: generateMarkersFromMap(state.places ?? {}, context, state, currentUser),
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
                                userId: currentUser.id,
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
                  Positioned(
                    top: 50.0, // Adjust the top position as needed
                    right: 10.0, // Adjust the right position as needed
                    child: SlidingButtonWidget(
                      onTapCallback: () {
                      _mapController?.setMapStyle(mapStyle3); // Reload the map when the map style changes
                      },
                      onTapCallback2:() => _mapController?.setMapStyle(mapStyle2),
                      onTapCallback3: () => _mapController?.setMapStyle(mapStyle1),
                    ),
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

Set<Marker> generateMarkersFromMap(
  Map<String, PostModel> postsMap, 
  BuildContext context, 
  LocationLoaded state, 
  UserModel currentUser) {
    Set<Marker> markers = {};

    postsMap.forEach((postId, post) {
      final Marker marker = Marker(
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
          print('HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
          print('PostId: $postId - OwnerId: ${owner.id}');
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
