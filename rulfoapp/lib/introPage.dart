import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'map.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Colors.purple, Colors.red, Colors.pink],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('lib/assets/logo.png', width: 300).animate().fadeIn(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 1500),
              ),

              const SizedBox(height: 2),
              const Text(
                'AC CONNECT',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'magistral',
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ).animate().fadeIn(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 1200),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MapScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '¡Vamos!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ).animate().fadeIn(
                delay: const Duration(milliseconds: 900),
                duration: const Duration(milliseconds: 1000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
