part of 'location_bloc.dart';
//Estados

/*Clase Abstracta, estructura de las demás clases que la hereden, no es instanciable*/
abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

// Simple estado de carga
class LocationLoading extends LocationState {}

// Cuando geolocator obtiene permisos y devuelve la localización del usuario
class LocationLoaded extends LocationState {
  final Position position;
  Map<String, PostModel>? places;
  final GoogleMapController? controller;
  List<UserModel>? friends;
  bool friendsPostsLoaded; 
  
  LocationLoaded({
    required this.position,
    this.places,
    this.controller,
    this.friends,
    this.friendsPostsLoaded = false,
  });

  @override
  List<Object?> get props => [position, places, controller, friendsPostsLoaded];

  // Metodo para reemitir el estado con diferentes valor o el mismo
  LocationLoaded copyWith(
      {Position? position,
      Map<String, PostModel>? places,
      GoogleMapController? controller,
      List<UserModel>? friends,
      bool? friendsPostsLoaded}) {
    return LocationLoaded(
      position: position ?? this.position,
      places: places ?? this.places,
      controller: controller ?? this.controller,
      friends: friends ?? this.friends,
      friendsPostsLoaded: friendsPostsLoaded ?? this.friendsPostsLoaded,
    );
  }
}

// Cuando no se obtienen los permisos
class LocationDenied extends LocationState {}

// Cuando hubo un error al pedir permisos.
class LocationError extends LocationState {
  final String errorMessage;
  const LocationError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

class LocationPlaceSelected extends LocationState {
  final PostModel place;
  const LocationPlaceSelected({required this.place});
}
