import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_it/authentication/data/models/user_model.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:map_it/friends/data/repository/friends_repository.dart';
part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final AuthRepository _authRepository;
  final FriendshipRepository _friendshipRepository;
  FriendsBloc(
      {required AuthRepository authRepo,
      required FriendshipRepository friendsRepo})
      : _authRepository = authRepo,
        _friendshipRepository = friendsRepo,
        super(FriendsInitial()) {
    on<AddFriend>(_onAddFriendship);
    on<DeleteFriend>(_onDeleteFriendship);
    on<LoadFriends>(_onLoadFriends);
  }
  _onLoadFriends(LoadFriends event, Emitter<FriendsState> emit) async {
    //llamado a la API
    List<UserModel>? friends = await _friendshipRepository.getUserFriends();
    if (friends != null) emit(FriendsLoaded(friends: friends));
  }

  _onAddFriendship(AddFriend event, Emitter<FriendsState> emit) async {
    UserModel? user = await _authRepository.getUserByName(event.userName);
    if (user != null) {
      bool res = await _friendshipRepository.addFriend(user.id);
      if (res == true) {
        emit(FriendAdded(user));
      } else {
        emit(FriendError());
      }
    } else {
      emit(FriendError());
    }
  }

  _onDeleteFriendship(DeleteFriend event, Emitter<FriendsState> emit) async {
    bool res = await _friendshipRepository.deleteFriend(event.userId);
    if (res == true) emit(FriendDeleted());
    if (res == false) emit(FriendError());
  }
}
