import 'package:flutter/material.dart';
import 'package:rulfoapp/pages/ComentarioPage.dart';
import 'package:rulfoapp/services/entrevista_service.dart';

class EntrevistaFormBuilder extends StatefulWidget {
  final List<Map<String, String>> preguntas;
  final void Function(Map<String, dynamic>) onSubmit;

  const EntrevistaFormBuilder({
    super.key,
    required this.preguntas,
    required this.onSubmit,
  });

  @override
  State<EntrevistaFormBuilder> createState() => _EntrevistaFormBuilderState();
}

class _EntrevistaFormBuilderState extends State<EntrevistaFormBuilder> {
  late List<Map<String, dynamic>> entrevista;
  late Map<String, TextEditingController> controllerMap;

  @override
  void initState() {
    super.initState();
    entrevista = widget.preguntas;
    controllerMap = {
      for (var p in entrevista) p['id_pregunta']!: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (var controller in controllerMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void cargarEntrevista() async {
    final perfilCliente = {
      "tipo_negocio": "cafetería",
      "zona": "zona Tec",
      "antiguedad_cliente": "2 años",
      "nombre_dueno": "María González",
      "edad": 42,
      "sexo": "femenino",
    };

    final preguntas = await EntrevistaService.obtenerGuiaEntrevista(
      perfilCliente,
    );
    setState(() {
      entrevista = preguntas;
      controllerMap = {
        for (var p in entrevista) p['id_pregunta']!: TextEditingController(),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...controllerMap.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: entry.value,
                            decoration: const InputDecoration(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      final respuestas = {
                        for (var e in controllerMap.entries)
                          e.key: e.value.text,
                      };
                      widget.onSubmit(respuestas);
                    },
                    child: Text("Enviar"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      final respuestas = {
                        for (var e in controllerMap.entries)
                          e.key: e.value.text,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ComentarioPage(respuestas: [respuestas]),
                        ),
                      );
                    },
                    child: Text("Observaciones"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
