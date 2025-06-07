import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/presentation/app_bloc_observer.dart';
import 'package:frontend_flutter/bloc/auth_bloc.dart';
import 'package:frontend_flutter/presentation/screens/signup_screen.dart';
import 'package:frontend_flutter/pallete.dart';
import 'package:frontend_flutter/presentation/screens/login_screen.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Multi-LLM-Chat',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Pallete.backgroundColor,
        ),
        home: const LoginScreen(),
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const SignUpScreen(), // Replace with HomeScreen when implemented
        '/login': (context) => const LoginScreen(), // Replace with LoginScreen when implemented
      }
      ),
    );
  }
}
