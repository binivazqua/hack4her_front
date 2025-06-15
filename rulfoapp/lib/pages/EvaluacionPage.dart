import 'package:flutter/material.dart';
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
            : SingleChildScrollView(child: Text(_evaluacion)),
      ),
    );
  }
}
