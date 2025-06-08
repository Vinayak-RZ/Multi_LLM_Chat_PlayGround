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

List<String> history = []; // To store response cards history

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  // To store response card history
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<LlmBlocBloc>().add(LlmBlocGoBack(responses: history));
          },
        ),
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
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(
                255,
                255,
                167,
                240,
              ), // Important for ShaderMask
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
          if (state is LlmBlocFailure) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LlmBlocInitial) {
            //normally it will be LlmBlocInitial
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
                      context.read<LlmBlocBloc>().add(
                        LlmFetchData(query: text),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is LlmDataFetched) {
            //for testing purposes normally it will be LlmBlocSuccess
            history.clear(); // Clear previous history
            history = [
              state.deepseekData,
              state.llamaData,
              state.mistralData,
              state.geminiData,
            ]; // Store the responses in history
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 2x2 Grid of Cards
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Deepseek",
                                  message: state.deepseekData,
                                  futureprompt: state.deepseekData,
                                ),
                              );
                            },
                            title: "Deepseek",
                            text: state.deepseekData,
                          ),
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Llama",
                                  message: state.llamaData,
                                  futureprompt: state.llamaData,
                                ),
                              );
                            },
                            title: "Llama",
                            text: state.llamaData,
                          ),
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Mistral",
                                  message: state.mistralData,
                                  futureprompt: state.mistralData,
                                ),
                              );
                            },
                            title: "Mistral",
                            text: state.mistralData,
                          ),
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Gemini",
                                  message: state.geminiData,
                                  futureprompt: state.geminiData,
                                ),
                              );
                            },
                            title: "Gemini",
                            text: state.geminiData,
                          ),
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
                          context.read<LlmBlocBloc>().add(
                            LlmFetchData(query: text),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state is LlmBlocHistory) {
            //for testing purposes normally it will be LlmBlocSuccess
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 2x2 Grid of Cards
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Deepseek",
                                  message: state.responses[0],
                                  futureprompt: state.responses[0],
                                ),
                              );
                            },
                            title: "Deepseek",
                            text: state.responses[0],
                          ),
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Llama",
                                  message: state.responses[1],
                                  futureprompt: state.responses[1],
                                ),
                              );
                            },
                            title: "Llama",
                            text: state.responses[1],
                          ),
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Mistral",
                                  message: state.responses[2],
                                  futureprompt: state.responses[2],
                                ),
                              );
                            },
                            title: "Mistral",
                            text: state.responses[2],
                          ),
                          ResponseCard(
                            onPressed: () {
                              context.read<LlmBlocBloc>().add(
                                LlmBlocGoInResponse(
                                  title: "Gemini",
                                  message: state.responses[3],
                                  futureprompt: state.responses[3],
                                ),
                              );
                            },
                            title: "Gemini",
                            text: state.responses[3],
                          ),
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
                          context.read<LlmBlocBloc>().add(
                            LlmFetchData(query: text),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (state is LlmBlocIndsideResponse) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    // Add scrolling here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 214, 75, 253),
                                    Color.fromARGB(255, 248, 57, 136),
                                    Color.fromARGB(255, 244, 130, 89),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(
                                  Rect.fromLTWH(
                                    0,
                                    0,
                                    bounds.width,
                                    bounds.height,
                                  ),
                                ),
                            child: Text(
                              state.title,
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 255, 182, 242),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(180, 20, 180, 0),
                          child: Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 255, 122, 193),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GradientButton(
                  onPressed: () {
                    context.read<LlmBlocBloc>().add(
                      LlmFetchData(query: state.futureprompt.trim()),
                    );
                  },
                  text: "Send Response to LLMs",
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: MessageInput(
                    controller: messageController,
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        // context.read<LlmBlocBloc>().add(SendMessage(text));
                        messageController.clear();
                      }
                      context.read<LlmBlocBloc>().add(
                        LlmFetchData(query: text),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
