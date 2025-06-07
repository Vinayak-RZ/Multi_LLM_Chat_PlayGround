import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/bloc/auth_bloc.dart';
import 'package:frontend_flutter/presentation/screens/signup_screen.dart';
import 'package:frontend_flutter/presentation/widgets/gradient_button.dart';
import 'package:frontend_flutter/presentation/screens/login_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              children: [
                Text((state as AuthSuccess).uid),
                GradientButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  text: 'Logout',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
