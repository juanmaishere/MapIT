part of 'friends_bloc.dart';

abstract class FriendsEvent extends Equatable {
  const FriendsEvent();
}

class AddFriend extends FriendsEvent {
  final String userName;

  const AddFriend(this.userName);

  @override
  List<Object?> get props => [userName];
}

class DeleteFriend extends FriendsEvent {
  final UserModel user;

  const DeleteFriend({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoadFriends extends FriendsEvent {
  List<UserModel>? friends;

  LoadFriends();

    @override
  List<Object?> get props => [friends];
}