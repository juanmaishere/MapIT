import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:map_it/friends/data/repository/friends_repository.dart';
import 'package:map_it/friends/presentation/bloc/friends_bloc.dart';
import '../../widgets/friendsrow_model.dart';
class FriendsScreen extends StatelessWidget {
  FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsBloc(authRepo: AuthRepository(), friendsRepo: FriendshipRepository()), // Provide your FriendsBloc here
      child: Scaffold(
        body: BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            if (state is FriendsInitial) {
              context.read<FriendsBloc>().add(LoadFriends());
              return const CircularProgressIndicator();
            } else if (state is FriendsLoaded) {
              return SingleChildScrollView(
                child: ListView.builder(
                  itemCount: state.friends!.length,
                  itemBuilder: (context, index) {
                    return FriendsRowWidget(user: state.friends![index]);
                  },
                ),
              );
            } else {
              return const Text('Something went wrong!');
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add a friend'),
                  content: TextField(
                    onSubmitted: (value) {
                      context.read<FriendsBloc>().add(AddFriend(value));
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}