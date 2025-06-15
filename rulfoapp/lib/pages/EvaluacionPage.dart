import 'package:flutter/material.dart';
import 'package:rulfoapp/pages/Recomendacion_page.dart';
import 'package:rulfoapp/services/evaluacion_service.dart';

class EvaluacionPage extends StatefulWidget {
  final List<Map<String, String>> respuestas;

  const EvaluacionPage({super.key, required this.respuestas});

  @override
  State<EvaluacionPage> createState() => _EvaluacionPageState();
}

class _EvaluacionPageState extends State<EvaluacionPage> {
  String _evaluacion = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _generarEvaluacion();
  }

  Future<void> _generarEvaluacion() async {
    try {
      final resultado = await EvaluacionService.generarEvaluacion(
        widget.respuestas,
      );
      setState(() {
        _evaluacion = resultado;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _evaluacion = 'Error al generar evaluación: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Evaluación del establecimiento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text(_evaluacion),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          // 🔁 Re-generar evaluación para asegurar que esté actualizada
                          final nuevaEvaluacion =
                              await EvaluacionService.generarEvaluacion(
                                widget.respuestas,
                              );

                          final mensaje =
                              await EvaluacionService.guardarEvaluacion(
                                respuestas: widget.respuestas,
                                puntoId:
                                    "pv_017754fa-f705-4866-86e1-9bccec5522af",
                                visitaId:
                                    "visita_54c92eaf-ee32-40e5-915f-4cfa2757e50c",
                              );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(mensaje)));

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecomendacionPage(
                                evaluacion:
                                    nuevaEvaluacion, // ← usamos la regenerada
                                puntoId:
                                    "pv_017754fa-f705-4866-86e1-9bccec5522af",
                                visitaId:
                                    "visita_54c92eaf-ee32-40e5-915f-4cfa2757e50c",
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      },
                      child: const Text("Guardar y continuar"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
