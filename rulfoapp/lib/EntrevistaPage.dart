import 'package:flutter/material.dart';
import 'package:rulfoapp/services/entrevista_service.dart';
import 'package:rulfoapp/widgets/entrevista_form_builder.dart';
import 'package:rulfoapp/widgets/snackbar_confirmacion.dart';

class EntrevistaPage extends StatefulWidget {
  const EntrevistaPage({Key? key}) : super(key: key);

  @override
  State<EntrevistaPage> createState() => _EntrevistaPageState();
}

class _EntrevistaPageState extends State<EntrevistaPage> {
  List<Map<String, dynamic>> preguntas = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    try {
      final perfilCliente = {
        "tipo_negocio": "cafetería",
        "zona": "zona Tec",
        "antiguedad_cliente": "2 años",
        "nombre_dueno": "María González",
        "edad": 42,
        "sexo": "femenino",
      };

      final preguntasObtenidas = await EntrevistaService.obtenerGuiaEntrevista(
        perfilCliente,
      );
      setState(() {
        preguntas = preguntasObtenidas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al obtener preguntas: $e';
        isLoading = false;
      });
    }
  }

  void handleSubmit(Map<String, dynamic> respuestasMap) {
    print('✅ Respuestas enviadas:');

    final respuestasList = respuestasMap.entries
        .map((entry) => {"id_pregunta": entry.key, "respuesta": entry.value})
        .toList();

    for (var r in respuestasList) {
      print('${r["id_pregunta"]}: ${r["respuesta"]}');
    }

    // Aquí podrías llamar directamente a tu servicio de evaluación o guardado:
    // EvaluacionService.enviarEvaluacion(respuestasList, colaborador, cliente);

    // Mostrar feedback visual con un SnackBar de confirmación
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Respuestas enviadas correctamente'),
    //     backgroundColor: Colors.green,
    //     duration: Duration(seconds: 2),
    //   ),
    // );
    // Usar el widget especial SnackbarConfirmacion
    SnackbarConfirmacion.show(
      context,
      mensaje: 'Respuestas enviadas correctamente',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrevista"),
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
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(
                child: Text(error, style: const TextStyle(color: Colors.red)),
              )
            : EntrevistaFormBuilder(
                preguntas: preguntas
                    .map(
                      (q) => q.map(
                        (key, value) => MapEntry(key, value.toString()),
                      ),
                    )
                    .toList(),
                onSubmit: handleSubmit,
              ),
      ),
    );
  }
}
