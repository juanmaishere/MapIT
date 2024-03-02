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
  final List<PostModel>? places;
  final GoogleMapController? controller;
  const LocationLoaded({
    required this.position,
    this.places,
    this.controller,
  });
  @override
  List<Object?> get props => [position, places, controller];
  // Metodo para reemitir el estado con diferentes valor o el mismo
  LocationLoaded copyWith(
      {Position? position,
      List<PostModel>? places,
      GoogleMapController? controller}) {
    return LocationLoaded(
      position: position ?? this.position,
      places: places ?? this.places,
      controller: controller ?? this.controller,
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