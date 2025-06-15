import 'package:flutter/material.dart';
import 'package:rulfoapp/services/comentario_service.dart';
import 'package:rulfoapp/widgets/VoiceCommentInput.dart';

class ComentarioPage extends StatefulWidget {
  const ComentarioPage({super.key});

  @override
  State<ComentarioPage> createState() => _ComentarioPageState();
}

class _ComentarioPageState extends State<ComentarioPage> {
  String _comentarioGenerado = "";

  void _procesarComentario(String texto) async {
    final puntoId =
        'pv_017754fa-f705-4866-86e1-9bccec5522af'; // usa IDs válidos
    final visitaId = 'visita_54c92eaf-ee32-40e5-915f-4cfa2757e50c';

    try {
      final resultado = await ComentarioService.enviarComentario(
        comentario: texto,
        puntoId: puntoId,
        visitaId: visitaId,
      );
      setState(() => _comentarioGenerado = resultado);
    } catch (e) {
      setState(() => _comentarioGenerado = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comentario del colaborador")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //VoiceCommentInput(onResult: _procesarComentario),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Escribe tu comentario',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _procesarComentario,
            ),
            const SizedBox(height: 20),
            Text(
              "Comentario resumido:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_comentarioGenerado),
          ],
        ),
      ),
    );
  }
}
