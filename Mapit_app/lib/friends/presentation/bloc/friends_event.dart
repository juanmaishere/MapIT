part of 'friends_bloc.dart';
abstract class FriendsEvent extends Equatable {
  const FriendsEvent();
}
class AddFriend extends FriendsEvent {
  final String userId;
  const AddFriend(this.userId);
  @override
  List<Object?> get props => [userId];
}
class DeleteFriend extends FriendsEvent {
  final String userId;
  const DeleteFriend(this.userId);
  @override
  List<Object?> get props => [userId];
}
class LoadFriends extends FriendsEvent {
  List<UserModel>? friends;
  LoadFriends();
    @override
  List<Object?> get props => [friends];
}