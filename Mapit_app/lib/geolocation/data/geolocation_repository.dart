import 'package:geolocator/geolocator.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

/* 
Clase abstracta BaseGeolocationRepository:
  Esta clase sirve como una interfaz que define el que deben tener todas las clases que la implementen.
  Definimos un método getCurrentLocation que devuelve un Future<LocationState>, un estado de la localización. 
*/
abstract class BaseGeolocationRepository {
  Future<LocationState> getCurrentLocation();
}

class GeolocationRepository extends BaseGeolocationRepository {
  GeolocationRepository();

  @override
  Future<LocationState> getCurrentLocation() async {
    try {
      // Primero se verifica el permiso de ubicación actual en el dispositivo
      LocationPermission permission = await Geolocator.checkPermission();

      // Si el permiso de ubicación está denegado, se solicita el permiso de ubicación al usuario.
      if (permission == LocationPermission.denied) {
        /*
        Si el permiso de ubicación está denegado para siempre o sigue estando denegado después de
        la solicitud, se devuelve un estado LocationDenied.
        */
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          return LocationDenied();
        }
      }
      /*
      Si el permiso de ubicación está permitido, se obtiene y devuelve la ubicación actual del dispositivo.
       - LocationPermission.whileInUse: El permiso de ubicación se concede solo cuando la aplicación está en uso.
       - LocationPermission.always: El permiso de ubicación se concede siempre, incluso cuando la aplicación no está en uso.
      El parámetro desiredAccuracy indica la precisión deseada de los datos de ubicación.
      */
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LocationLoaded(position: position);
    } catch (e) {
      //Manejo de exepciones
      return LocationError(e.toString());
    }
  }
}
