import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_flutter/bloc/auth_bloc.dart';
import 'package:frontend_flutter/bloc/bloc/llm_bloc_bloc.dart';
import 'package:frontend_flutter/pallete.dart';
import 'package:frontend_flutter/presentation/screens/login_screen.dart';
import 'package:frontend_flutter/presentation/widgets/message_input.dart';
import 'package:frontend_flutter/presentation/widgets/response_card.dart';
import 'package:frontend_flutter/presentation/widgets/gradient_button.dart';

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
            colors: [
              Color.fromARGB(255, 214, 75, 253),
              Color.fromARGB(255, 248, 57, 136),
              Color.fromARGB(255, 244, 130, 89),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: const Text(
            'Multi-LLM-Chat PlayGround',
            style: TextStyle(
              fontSize: 35,
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
          if (state is LlmBlocFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }

          if (state is LlmBlocInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is LlmBlocLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LlmBlocFailure) {//normally it will be LlmBlocInitial
            return SingleChildScrollView(
            child:Column(
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
            ),
            );
          }
          if (state is LlmBlocInitial) {//for testing purposes normally it will be LlmBlocSuccess
            return SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.all(20.0),
              child:
               Center(
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 2x2 Grid of Cards
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        ResponseCard(onPressed:(){}, title: "Deepseek",text: 'To manage your tasks and projects, Deepseek is a powerful tool that helps you stay organized and efficient.'),
                        ResponseCard(onPressed:(){}, title: "Llama",text: 'I want all the information you need to make informed decisions and stay ahead of the competition.'),
                        ResponseCard(onPressed:(){}, title: "Mistral",text: 'Give me the power to create stunning visuals and graphics that will captivate your audience.'),
                        ResponseCard(onPressed:(){},title: "Gemini",text: 'Sex is a natural and healthy part of life, and it can be a source of pleasure and intimacy for many people.'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      onPressed: () {
                        // context.read<LlmBlocBloc>().add(LoadMessages());
                      },
                      text: "Tap Response Cards to see more",
                    ),
                    const SizedBox(height: 20),
                    // Message Input Bar
                    MessageInput(
                      controller: messageController,
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          // context.read<LlmBlocBloc>().add(SendMessage(text));
                          messageController.clear();
                        }
                      },
                    ),
                  ],
                               ),
               ),
            ),
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
