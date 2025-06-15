import 'dart:convert';
import 'package:http/http.dart' as http;

class RecomendacionService {
  static const String _baseUrl =
      'https://absolute-live-sheepdog.ngrok-free.app'; // reemplaza con tu endpoint real

  static Future<String> obtenerRecomendaciones(String evaluacionTexto) async {
    final url = Uri.parse('$_baseUrl/recomendaciones-inmediatas');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"evaluacion": evaluacionTexto}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["recomendaciones"] ?? '';
    } else {
      throw Exception('Error al obtener recomendaciones: ${response.body}');
    }
  }
}
