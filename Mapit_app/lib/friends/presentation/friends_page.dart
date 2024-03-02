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
      create: (context) => FriendsBloc(
          authRepo: AuthRepository(), friendsRepo: FriendshipRepository()),
      child: Scaffold(
        body: BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            print("Current State: $state"); // Add this line for debugging

            if (state is FriendsInitial) {
              context.read<FriendsBloc>().add(LoadFriends());
              return Center(child: CircularProgressIndicator());
            } else if (state is FriendsLoaded) {
              return Column(children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Friends',
                        style: TextStyle(
                          fontFamily: 'DonGraffiti',
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 3,
                  height: 0,
                  indent: 50,
                  endIndent: 50,
                  color: Color.fromARGB(255, 2, 25, 48),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: state.friends!.length,
                    itemBuilder: (context, index) {
                      return FriendsRowWidget(user: state.friends![index]);
                    },
                  ),
                ),
              ]);
            } else if (state is FriendError) {
              return Text('Error');
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
