import 'package:flutter/material.dart';
import 'package:rulfoapp/pages/EvaluacionPage.dart';
import 'package:rulfoapp/services/comentario_service.dart';
import 'package:rulfoapp/services/confirmacion_service.dart';
import 'package:rulfoapp/services/evaluacion_service.dart';
import 'package:rulfoapp/widgets/VoiceCommentInput.dart';
import 'package:rulfoapp/widgets/snackbar_confirmacion.dart';

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
      appBar: AppBar(
        title: const Text("Guía de Actitud"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple,
                Colors.red,
                Colors.pink, // Tercer color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            VoiceCommentInput(onResult: _procesarComentario),

            /*
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 300,
                child: TextField(
                  controller: _textoController,
                  decoration: const InputDecoration(
                    labelText: 'Escribe tu comentario',
                    border: InputBorder.none,
                  ),
                  maxLines: 4,
                  minLines: 2,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),*/
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                _procesarComentario(_textoController.text);
                SnackbarConfirmacion.show(
                  context,
                  mensaje: "Comentario enviado exitosamente",
                );
              },
              child: Text("Enviar Observación"),
            ),

            const SizedBox(height: 8),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EvaluacionPage(respuestas: widget.respuestas),
                  ),
                );
              },
              child: const Text("Terminar entrevista"),
            ),
          ],
        ),
      ),
    );
  }
}
