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
  final TextEditingController _usernameController = TextEditingController();

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
              // Emitir un evento en el LocationBloc para cargar los lugares de los amigos
              if (context.read<LocationBloc>().state is LocationLoaded) {
                context.read<LocationBloc>().add(LoadNewFriendPosts(friend: state.friend));
              }
            }
            if (state is FriendDeleted) {
              // Emitir un evento en el LocationBloc para cargar los lugares de los amigos
              if (context.read<LocationBloc>().state is LocationLoaded) {
                context.read<LocationBloc>().add(DeleteFriendPosts(friend: state.friend));
              }
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
                print('Amigos: ${state.friends}');
                return ListView.builder(
                  itemCount: state.friends!.length,
                  itemBuilder: (context, index) {
                    print(state.friends![index]);
                    return FriendsRowWidget(user: state.friends![index]);
                  },
                );
            } else if (state is FriendError){
              return const Text('Something went wrong!');
            } else {
              return const SizedBox.shrink();
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
                  content: Column(
                    children: [
                      const Text('Enter the username of your friend'),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Enter username',
                        )
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final username = _usernameController.text;
                              if (username.isEmpty) {
                                // Muestra un mensaje de error al usuario
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Por favor, ingrese un valor.')),
                                );
                              } else {
                                // Envía el valor al BLoC
                                context.read<FriendsBloc>().add(AddFriend(username));
                                Navigator.of(context).pop();
                                _usernameController.text = '';
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ) 
                );
              },
            );
          },
        ),
      )
    );
  }
}
