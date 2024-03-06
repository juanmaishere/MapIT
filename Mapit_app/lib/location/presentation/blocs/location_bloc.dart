import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
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
    on<LoadFriendsPost>(_onLoadFriendsPost);
    on<LoadNewFriendPosts>(_onLoadNewFriendPosts);
    on<DeleteFriendPosts>(_onDeleteFriendPosts);
  }
  // Creamos la acción del evento LoadMap, le pasamos como argumento el evento y el emisor de estado
  void _onLoadMap(LoadMap event, Emitter<LocationState> emit) async {
    final LocationState state =
        await _geolocationRepository.getCurrentLocation();
    final posts = await _postRepository.getUserPost(event.user.id);
    if (state is LocationLoaded) {
      emit(LocationLoaded(
          //Acá podemos agregar los places cercanos o todos directamente, pero primero hay que crear esas funciones
          position: state.position,
          controller: event.controller,
          places: <String, PostModel>{for (var post in posts ?? []) post.postId!: post}
          )
      );
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
        Map<String, PostModel> newPlaces = Map.from(loadedState.places ?? {});
        newPlaces[event.post.postId!] = event.post;
        emit(loadedState.copyWith());
      } else {
        print("Error al agregar lugar");
      }
    }

    // Emite un nuevo estado con los marcadores actualizados
  }

  void _onLoadFriendsPost(LoadFriendsPost event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      LocationLoaded loadedState = state as LocationLoaded;
      if (loadedState.friendsPostsLoaded == false) {
        for (final friend in event.friends) {
          print('Friend: $friend');
          try {
            List<PostModel>? posts = await _postRepository.getUserPost(friend.id);
            if (posts != null) {
              posts.forEach((element) { 
                if (loadedState.places![element.postId] == null) {
                  loadedState.places![element.postId!] = element;
                }
              });
            }
          } catch (e) {
            print('Error loading posts for friend ${friend.id}: $e');
          }
      }
        emit(loadedState.copyWith(friends: event.friends, friendsPostsLoaded: true));
      }
      
    } else {
      print('El estado actual no es LocationLoaded');
    }
  }

  void _onLoadNewFriendPosts(LoadNewFriendPosts event, Emitter<LocationState> emit) async {
    if (state is LocationLoaded) {
      LocationLoaded loadedState = state as LocationLoaded;
      try {
        List<PostModel>? posts = await _postRepository.getUserPost(event.friend.id);
        if (posts != null) {
          posts.forEach((element) { 
            if (loadedState.places![element.postId] == null) {
              loadedState.places![element.postId!] = element;
            }
          });
        }
      } catch (e) {
        print('Error loading posts for friend ${event.friend.id}: $e');
      }
      emit(loadedState.copyWith());
    } else {
      print('El estado actual no es LocationLoaded');
    }
  }

  void _onDeleteFriendPosts(DeleteFriendPosts event, Emitter<LocationState> emit) {
    if (state is LocationLoaded) {
      LocationLoaded loadedState = state as LocationLoaded;
      loadedState.places!.removeWhere((key, value) => key == event.friend.id);
      emit(loadedState.copyWith());
    } else {
      print('El estado actual no es LocationLoaded');
    }
  }

}
