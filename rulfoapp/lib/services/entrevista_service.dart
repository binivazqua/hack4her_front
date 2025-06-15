import 'dart:convert';
import 'package:http/http.dart' as http;

class EntrevistaService {
  static const _baseUrl = 'http://127.0.0.1:8000';

  static Future<List<Map<String, String>>> obtenerGuiaEntrevista(
    Map<String, dynamic> perfilCliente,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/generar-guia-entrevista'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(perfilCliente),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['entrevista'] as List)
          .map((item) => Map<String, String>.from(item as Map))
          .toList();
    } else {
      throw Exception('Falló al obtener entrevista: ${response.body}');
    }
  }
}
