import 'package:flutter/material.dart';
import 'package:rulfoapp/map.dart';
import 'package:rulfoapp/pages/Recomendacion_page.dart';
import 'package:rulfoapp/services/evaluacion_service.dart';
import 'package:rulfoapp/widgets/snackbar_confirmacion.dart';

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
      appBar: AppBar(
        title: const Text("Evaluación"),
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MapScreen()),
              (route) => false, // Elimina el historial de navegación
            );
          },
        ),
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
        padding: const EdgeInsets.all(30.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text(_evaluacion, textAlign: TextAlign.justify),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[100],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              content: Row(
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(width: 16),
                                  const Expanded(
                                    child: Text("Creando recomendaciones..."),
                                  ),
                                ],
                              ),
                            ),
                          );

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

                          if (mounted)
                            Navigator.of(context).pop(); // Cierra el diálogo

                          SnackbarConfirmacion.show(context, mensaje: mensaje);

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
                          SnackbarConfirmacion.show(
                            context,
                            mensaje: 'Error al guardar evaluación: $e',
                            backgroundColor: Colors.red,
                          );
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
