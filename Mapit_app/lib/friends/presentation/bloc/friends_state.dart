part of 'friends_bloc.dart';

class FriendsState {
  List<UserModel>? friends;

  FriendsState({this.friends});
}

class FriendsInitial extends FriendsState {}

class FriendDeleted extends FriendsState {
  final UserModel friend;

  FriendDeleted(
    {required this.friend, required List<UserModel>? friends}
  ) : super(friends: friends);
}

class FriendAdded extends FriendsState {
  final UserModel friend;

  FriendAdded(
    {required this.friend, required List<UserModel>? friends}
  ) : super(friends: friends);
}

class FriendError extends FriendsState {}

class FriendsLoaded extends FriendsState {
  FriendsLoaded({required List<UserModel>? friends}) : super(friends: friends);
}
