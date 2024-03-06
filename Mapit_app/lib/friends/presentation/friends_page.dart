import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_it/friends/presentation/bloc/friends_bloc.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/widgets/friendsrow_model.dart';

/* 
Optimización de rendimiento: Si la lista de amigos puede ser grande, podrías considerar implementar un mecanismo de paginación o de carga perezosa para evitar cargar todos los amigos de una vez, lo que podría afectar el rendimiento de la aplicación.   
*/

class FriendsScreen extends StatelessWidget {
  FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FriendsBloc, FriendsState>(
          listener: (context, state) {
            if (state is FriendsLoaded) {
              // Emitir un evento en el LocationBloc para cargar los lugares de los amigos
              if (context.read<LocationBloc>().state is LocationLoaded) {
               context.read<LocationBloc>().add(LoadFriendsPost(friends: state.friends!));
              }
            }
            if (state is FriendAdded) {

            }
            if (state is FriendDeleted) {

            }
          },
        ),
        BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
              // Emitir un evento en el FriendsBloc para cargar los amigos
              context.read<FriendsBloc>().add(LoadFriends());
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('My Friends')),
        body: BlocBuilder<FriendsBloc, FriendsState>(
          builder: (context, state) {
            if (state is FriendsInitial) {
              context.read<FriendsBloc>().add(LoadFriends());
              return const CircularProgressIndicator();
            } else if (
              state is FriendsLoaded || 
              state is FriendDeleted || 
              state is FriendAdded) { 
                return ListView.builder(
                  itemCount: state.friends!.length,
                  itemBuilder: (context, index) {
                    return FriendsRowWidget(user: state.friends![index]);
                  },
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
      )
    );
  }
}