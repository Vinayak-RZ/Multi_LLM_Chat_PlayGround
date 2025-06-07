import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/bloc/auth_bloc.dart';
import 'package:frontend_flutter/presentation/screens/home_screen.dart';
import 'package:frontend_flutter/presentation/widgets/gradient_button.dart';
import 'package:frontend_flutter/presentation/widgets/login_field.dart';
//import 'package:frontend_flutter/widgets/social_button.dart';
import 'package:frontend_flutter/presentation/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => __LoginScreenState();
}

class __LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }

          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/images/signin_balls.png'),
                  const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 15),
                  LoginField(hintText: 'Email', controller: emailController),
                  const SizedBox(height: 15),
                  LoginField(
                    hintText: 'Password',
                    controller: passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Haven't signed up? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginRequested(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      );
                    },

                    text: "Login",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
