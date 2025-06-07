import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/bloc/auth_bloc.dart';
import 'package:frontend_flutter/bloc/bloc/llm_bloc_bloc.dart';
import 'package:frontend_flutter/pallete.dart';
import 'package:frontend_flutter/presentation/screens/login_screen.dart';
import 'package:frontend_flutter/presentation/widgets/message_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color.fromARGB(255, 214, 75, 253), Color.fromARGB(255, 248, 57, 136), Color.fromARGB(255, 244, 130, 89)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: const Text(
            'Multi-LLM-Chat PlayGround',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: Colors.white, // Important for ShaderMask
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 30, color: Colors.white),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<LlmBlocBloc, LlmBlocState>(
        listener: (context, state) {
          // handle specific state transitions here if needed
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Ask Whatever You Want, To multiple LLMs \n'
                    '         and get response in real-time!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: MessageInput(
                  controller: messageController,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      //context.read<LlmBlocBloc>().add(SendMessage(text));
                      messageController.clear();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
