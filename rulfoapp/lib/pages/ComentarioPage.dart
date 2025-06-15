import 'package:flutter/material.dart';
import 'package:rulfoapp/pages/EvaluacionPage.dart';
import 'package:rulfoapp/services/comentario_service.dart';
import 'package:rulfoapp/services/evaluacion_service.dart';
import 'package:rulfoapp/widgets/VoiceCommentInput.dart';

class ComentarioPage extends StatefulWidget {
  final List<Map<String, String>> respuestas;
  const ComentarioPage({super.key, required this.respuestas});

  @override
  State<ComentarioPage> createState() => _ComentarioPageState();
}

class _ComentarioPageState extends State<ComentarioPage> {
  TextEditingController _textoController = TextEditingController();
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
              controller: _textoController,
              decoration: InputDecoration(labelText: 'Escribe tu comentario'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _procesarComentario(_textoController.text);
              },
              child: Text("Enviar Observación"),
            ),
            Text(
              "Comentario resumido:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_comentarioGenerado),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EvaluacionPage(respuestas: widget.respuestas),
                  ),
                );
              },
              child: const Text("Enviar Evaluación"),
            ),
          ],
        ),
      ),
    );
  }
}
