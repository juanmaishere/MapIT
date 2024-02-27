import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_it/geolocation/data/geolocation_repository.dart';
import 'package:map_it/post/data/models/post_model.dart';
import 'package:map_it/post/data/repositories/post_repositories.dart';
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final PostRepository _postRepository;
  final GeolocationRepository _geolocationRepository;
  //Constructor del bloque -> Estado Inicial LocationLoading()
  LocationBloc({
    required PostRepository postRepo,
    required GeolocationRepository geolocationRepo,
  })  : _postRepository = postRepo,
        _geolocationRepository = geolocationRepo,
        super(LocationLoading()) {
    on<LoadMap>(_onLoadMap);
    on<AddPlace>(_onAddPlace);
  }
  // Creamos la acción del evento LoadMap, le pasamos como argumento el evento y el emisor de estado
  void _onLoadMap(LoadMap event, Emitter<LocationState> emit) async {
    final LocationState state =
        await _geolocationRepository.getCurrentLocation();
        final posts = await _postRepository.getUserPost(event.userId);
    if (state is LocationLoaded) {
      emit(LocationLoaded(
          //Acá podemos agregar los places cercanos o todos directamente, pero primero hay que crear esas funciones
          position: state.position,
          controller: event.controller,
          places: posts));
      return;
    }
    // En caso de falla o denied emitimos el estado devuelto
    emit(state);
  }

  void _onAddPlace(AddPlace event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      LocationLoaded loadedState = state as LocationLoaded;

      var respuesta = await _postRepository.UserPostToDb(event.post);
      // Agrega el nuevo marcador a la lista de marcadores
      if (respuesta == true) {
      List<PostModel> newPlaces = List.from(loadedState.places ?? [])
        ..add(event.post);
         emit(loadedState.copyWith(places: newPlaces)); 
      }
      else {
        print("Error al agregar lugar");
      }
    }    

      // Emite un nuevo estado con los marcadores actualizados
    
  }
}
