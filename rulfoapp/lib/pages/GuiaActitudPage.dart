import 'package:flutter/material.dart';
import 'package:rulfoapp/services/actitud_service.dart';

class GuiaActitudPage extends StatefulWidget {
  const GuiaActitudPage({super.key});

  @override
  State<GuiaActitudPage> createState() => _GuiaActitudPageState();
}

class _GuiaActitudPageState extends State<GuiaActitudPage> {
  String? guia;
  String error = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarGuia();
  }

  Future<void> cargarGuia() async {
    final perfilCliente = {
      "tipo_negocio": "cafetería",
      "zona": "zona Tec",
      "antiguedad_cliente": "2 años",
      "nombre_dueno": "María González",
      "edad": 42,
      "sexo": "femenino",
    };

    try {
      final resultado = await ActitudService.obtenerGuiaActitud(perfilCliente);
      setState(() {
        guia = resultado;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guía de Actitud")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(
              child: Text(error, style: const TextStyle(color: Colors.red)),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recomendación para el trato al cliente:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(guia!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/entrevista'),
                      child: const Text("Comenzar entrevista"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
