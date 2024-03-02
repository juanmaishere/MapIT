part of 'location_bloc.dart';
/*
  En este archivo podemos agregar mas eventos
  Por ejemplo un SearchLocation que me lleve a un punto que he buscado
*/
abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}
// Simple evento de renderización de mapa
class LoadMap extends LocationEvent {
  final GoogleMapController? controller;
  // Add BuildContext parameter
  final UserModel user;
  const LoadMap({this.controller, required this.user});
  @override
  List<Object?> get props => [controller];
}
class AddPlace extends LocationEvent {
  final Position position;
  final String userId;
  final PostModel post;
  const AddPlace({required this.position, required this.userId, required this.post});
  @override
  List<Object?> get props => [position, userId];
}

class LoadFriendsPost extends LocationEvent {
  final List<UserModel> friends;

  LoadFriendsPost({required this.friends});
}
class LoadFriendPost extends LocationEvent {}
class DeleteFriendPost extends LocationEvent {}