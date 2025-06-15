import 'package:flutter/material.dart';

class EncuestaScreen extends StatelessWidget {
  const EncuestaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuesta'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text('Aquí va la pantalla de la encuesta'),
      ),
    );
  }
}
