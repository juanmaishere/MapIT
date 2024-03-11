import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:map_it/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:map_it/authentication/presentation/widgets/form_container.dart';
import 'package:map_it/introduction/presentation/introduction_screen.dart';
import 'package:map_it/navigation/stackpage.dart';
import 'log_in_screen.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepo: AuthRepository()),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }

            if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => IntroductionScreens()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.fromLTRB(25, 100, 25, 100),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 228, 55, 55),
                    Color.fromARGB(255, 22, 122, 228),
                  ], // Replace with your gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.0,
                    1.0
                  ], // Adjust stops for gradient color distribution
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('lib/assets/mapit.png'),
                            height: 200,
                            width: 200,
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FormContainerWidget(
                            controller: _usernameController,
                            hintText: "Username",
                            isPasswordField: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FormContainerWidget(
                            controller: _emailController,
                            hintText: "Email",
                            isPasswordField: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FormContainerWidget(
                            controller: _passwordController,
                            hintText: "Password",
                            isPasswordField: true,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<AuthBloc>().add(
                                    AuthSignUpRequested(
                                      name: _usernameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 42, 130),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                  child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?"),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        (route) => false);
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(height: 60),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
