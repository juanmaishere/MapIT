import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/geolocation/data/geolocation_repository.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/repositories/post_repositories.dart';
import 'package:map_it/post/presentation/widget/post_form.dart';
import 'package:map_it/post/presentation/widget/post_modal.dart';
import '../../../assets/mapstyles.dart';
import '../../../widgets/maptype_widget.dart';
import '../../../authentication/data/repositories/auth_repository.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);
  final UserModel currentUser = AuthRepository().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Crea el Bloc y dispara el evento LoadMap para cambiar el estado
        final bloc = LocationBloc(
            postRepo: PostRepository(),
            geolocationRepo: GeolocationRepository());
        bloc.add(LoadMap(userId: currentUser.id));
        return bloc;
      },
      child: Scaffold(
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
                      controller.setMapStyle(mapStyle1);
                      context.read<LocationBloc>().add(LoadMap(
                          controller: controller, userId: currentUser.id));
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          state.position.latitude, state.position.longitude),
                      zoom: 15,
                    ),
                    padding: EdgeInsets.only(top: 50.0),
                    markers: state.places?.map((post) {
                          return Marker(
                              markerId: MarkerId('${post.postId}'),
                              position: LatLng(post.lat, post.lng),
                              onTap: () {
                                final postTapped = state.places?.firstWhere(
                                    (p) =>
                                        p.lat == post.lat && p.lng == post.lng);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext contextDialog) {
                                    return PostModal(
                                      title: postTapped!.title,
                                      content: postTapped.content,
                                      user: currentUser,
                                      post: postTapped,
                                      bloc: BlocProvider.of<LocationBloc>(
                                          context),
                                    );
                                  },
                                );
                              });
                        }).toSet() ??
                        {},
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: ElevatedButton.icon(
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
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: Text(''),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 2, 25, 34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50.0, // Adjust the top position as needed
                    right: 10.0, // Adjust the right position as needed
                    child: SlidingButtonWidget(
                      onMapStyleChanged: () {
                        // Reload the map when the map style changes
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
