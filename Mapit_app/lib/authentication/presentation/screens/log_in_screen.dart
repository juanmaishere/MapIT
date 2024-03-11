import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:map_it/authentication/data/repositories/auth_repository.dart';
import 'package:map_it/authentication/presentation/blocs/authentication_bloc.dart';
import 'package:map_it/authentication/presentation/widgets/form_container.dart';
import 'package:map_it/introduction/presentation/introduction_screen.dart';
import '../../../navigation/stackpage.dart';

import 'sign_up_screen.dart';

class LoginPage extends StatelessWidget {
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
                          SizedBox(height: 30),
                          Text(
                            "Log in",
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                          ),
                          SizedBox(
                            height: 30,
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
                            height: 20,
                          ),
                    GestureDetector(
                      onTap: () {
                        context.read<AuthBloc>().add(
                              AuthLoginRequested(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 233, 44, 44),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                              (route) => false,
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
