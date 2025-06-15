import 'package:flutter/material.dart';
import 'package:rulfoapp/services/recomendacion_service.dart';
import 'package:rulfoapp/services/confirmacion_service.dart';

class RecomendacionPage extends StatefulWidget {
  final String evaluacion;
  final String puntoId;
  final String visitaId;

  const RecomendacionPage({
    super.key,
    required this.evaluacion,
    required this.puntoId,
    required this.visitaId,
  });

  @override
  State<RecomendacionPage> createState() => _RecomendacionPageState();
}

class _RecomendacionPageState extends State<RecomendacionPage> {
  List<String> recomendaciones = [];
  bool isLoading = true;
  String error = '';
  String confirmacionMsg = '';

  @override
  void initState() {
    super.initState();
    _cargarRecomendaciones();
  }

  Future<void> _cargarRecomendaciones() async {
    try {
      final texto = await RecomendacionService.obtenerRecomendaciones(
        widget.evaluacion,
      );
      final lines = texto
          .replaceAll(
            RegExp(r'^\s*\[|\]\s*$'),
            '',
          ) // Elimina corchetes iniciales y finales
          .split('\n')
          .map(
            (line) => line
                .replaceFirst(RegExp(r'^[-•\s"]*'), '')
                .replaceAll('"', '')
                .trim(),
          )
          .where((line) => line.isNotEmpty && line != ',')
          .toList();

      print('🔍 Recomendaciones obtenidas:${texto}');
      setState(() {
        recomendaciones = lines;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "❌ $e";
        isLoading = false;
      });
    }
  }

  Future<void> _confirmarVisita() async {
    try {
      final msg = await ConfirmacionService.confirmarVisita(
        puntoId: widget.puntoId,
        visitaId: widget.visitaId,
      );
      setState(() => confirmacionMsg = msg);
    } catch (e) {
      setState(() => confirmacionMsg = '❌ Error al confirmar visita: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recomendaciones inmediatas")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(
                child: Text(error, style: const TextStyle(color: Colors.red)),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: recomendaciones.length,
                      itemBuilder: (context, index) {
                        final recomendacion = recomendaciones[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              recomendacion,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _confirmarVisita,
                    icon: const Icon(Icons.check),
                    label: const Text("Confirmar visita"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (confirmacionMsg.isNotEmpty)
                    Text(
                      confirmacionMsg,
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
      ),
    );
  }
}
