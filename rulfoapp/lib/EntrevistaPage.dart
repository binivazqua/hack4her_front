import 'package:flutter/material.dart';
import 'package:rulfoapp/services/entrevista_service.dart';
import 'package:rulfoapp/widgets/entrevista_form_builder.dart';

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

    // Lo transformamos a la estructura esperada por tu backend
    final respuestasList = respuestasMap.entries
        .map((entry) => {"id_pregunta": entry.key, "respuesta": entry.value})
        .toList();

    for (var r in respuestasList) {
      print('${r["id_pregunta"]}: ${r["respuesta"]}');
    }

    // Aquí podrías llamar directamente a tu servicio de evaluación o guardado:
    // EvaluacionService.enviarEvaluacion(respuestasList, colaborador, cliente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrevista', style:TextStyle(color: Colors.white)),
      backgroundColor:Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Colors.red, Colors.pink],
            ),
          ),
      ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Colors.purple, Colors.red, Colors.pink],
          ),
        ),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white
        ),
     inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
         focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(
                child: Text(error, style: const TextStyle(color: Colors.white)),
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
        ),
      ),
    );
  }
}
