import 'package:flutter/material.dart';
import 'package:frontend_flutter/presentation/screens/home_screen.dart';
import 'package:frontend_flutter/presentation/screens/login_screen.dart';
import 'package:frontend_flutter/presentation/screens/signup_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignUpScreen(),
  '/home': (context) => const HomeScreen(),

};