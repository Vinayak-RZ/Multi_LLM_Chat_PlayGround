import 'package:flutter/material.dart';
import 'package:frontend_flutter/pallete.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onSubmitted;

  const MessageInput({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return 
    ConstrainedBox
    (
      constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 100 ),  
      child: Padding(
      padding: const EdgeInsets.fromLTRB(16 , 8, 16, 16),
      child: TextField(
        style: const TextStyle(color: Color.fromARGB(255, 255, 81, 139), fontSize: 18),
        controller: controller,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: 'Type a message...',
          hintStyle: const TextStyle(color: Color.fromARGB(255, 189, 189, 189)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical:20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Pallete.borderColor, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Pallete.gradient2, width: 3),
          ),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
        ),
      ),
    )
    );
  }
}
