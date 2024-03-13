import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:map_it/friends/data/repository/friends_repository.dart';
import 'package:map_it/friends/presentation/bloc/friends_bloc.dart';
import 'package:map_it/geolocation/data/geolocation_repository.dart';
import 'package:map_it/location/presentation/blocs/location_bloc.dart';
import 'package:map_it/post/data/repositories/post_repositories.dart';
import 'authentication/presentation/screens/log_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GeolocationRepository>(
          create: (_) => GeolocationRepository(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<PostRepository>(
          create: (_) => PostRepository(),
        ),
        RepositoryProvider<FriendshipRepository>(
          create: (_) => FriendshipRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LocationBloc(
              geolocationRepo: context.read<GeolocationRepository>(),
              postRepo: context.read<PostRepository>(),
            )..add(LoadMap(user: context.read<AuthRepository>().currentUser!)),
          ),
          BlocProvider(
            create: (context) => FriendsBloc(
              authRepo: context.read<AuthRepository>(),
              friendsRepo: context.read<FriendshipRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginPage(),
        ),
      ),
    );
  }
}
