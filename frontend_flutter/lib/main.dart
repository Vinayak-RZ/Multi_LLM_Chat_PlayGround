import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/bloc/bloc/llm_bloc_bloc.dart';
import 'package:frontend_flutter/bloc/auth_bloc.dart';
import 'package:frontend_flutter/presentation/screens/signup_screen.dart';
import 'package:frontend_flutter/pallete.dart';
import 'package:frontend_flutter/presentation/screens/login_screen.dart';
import 'package:frontend_flutter/presentation/screens/home_screen.dart';
import 'package:frontend_flutter/routes/routes.dart';
import 'package:frontend_flutter/data/repositories/llm_repository.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
        BlocProvider<LlmBlocBloc>(create: (BuildContext context) => LlmBlocBloc(
           llmRepository: LLMRepository(),
        ),),
      ],
      child: MaterialApp(
        title: 'Multi-LLM-Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Pallete.backgroundColor,
        ),
        home: const LoginScreen(),
        routes: appRoutes,
      ),
    );
  }
}
