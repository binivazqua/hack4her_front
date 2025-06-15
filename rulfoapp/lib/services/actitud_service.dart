import 'dart:convert';
import 'package:http/http.dart' as http;

class ActitudService {
  static const _baseUrl = 'https://absolute-live-sheepdog.ngrok-free.app';

  static Future<String> obtenerGuiaActitud(
    Map<String, dynamic> perfilCliente,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/generar-guia-actitud'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(perfilCliente),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['respuesta'];
    } else {
      throw Exception('Error al generar guía de actitud: ${response.body}');
    }
  }
}
