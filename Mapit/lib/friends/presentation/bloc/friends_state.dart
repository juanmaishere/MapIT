part of 'friends_bloc.dart';
@immutable
sealed class FriendsState {}
class FriendsInitial extends FriendsState {}
class FriendDeleted extends FriendsState {}
class FriendAdded extends FriendsState {}
class FriendError extends FriendsState {}
class FriendsLoaded extends FriendsState {
  List<UserModel>? friends;
  FriendsLoaded({this.friends});
}



