import 'package:flutter/material.dart';
import 'package:frontend_flutter/pallete.dart';

class ResponseCard extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String title;
  const ResponseCard({
    super.key,
    required this.text,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 250,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 218, 110, 248),
              Color.fromARGB(255, 252, 131, 181),
              Color.fromARGB(255, 252, 172, 144),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color.fromARGB(255, 30, 41, 59), // A deep indigo/navy blue
            // Darker border
            width: 4,
          ),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(395, 55),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 30, 41, 59),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  child: Text(
                    text,
                    maxLines: 5,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
