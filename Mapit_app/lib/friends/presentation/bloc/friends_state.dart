part of 'friends_bloc.dart';

class FriendsState {
  List<UserModel>? friends;

}

class FriendsInitial extends FriendsState {}

class FriendDeleted extends FriendsState {
  final UserModel friend;

  FriendDeleted({required this.friend});
}

class FriendAdded extends FriendsState {
  final UserModel friend;

  FriendAdded({required this.friend});
}

class FriendError extends FriendsState {}

class FriendsLoaded extends FriendsState {

  FriendsLoaded();
}