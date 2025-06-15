import 'dart:convert';
import 'package:http/http.dart' as http;

class EvaluacionService {
  static const String _baseUrl =
      'https://b2ef-131-178-102-172.ngrok-free.app'; // ngrok o tu backend real

  static Future<String> generarEvaluacion(
    List<Map<String, String>> respuestas,
  ) async {
    // 🔐 Datos fijos del colaborador y cliente
    final body = {
      "cliente": {
        "tipo_negocio": "Cafetería",
        "zona": "Zona Tec",
        "antiguedad_cliente": "2 años",
        "nombre_dueno": "María González",
      },
      "respuestas": respuestas
          .map(
            (r) => {
              "id_pregunta": r["id_pregunta"] ?? '',
              "respuesta": r["respuesta"] ?? '',
            },
          )
          .toList(),
      "colaborador": "Ximena Ortiz",
    };

    final url = Uri.parse('$_baseUrl/evaluacion-completa');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['evaluacion'] ?? 'Evaluación generada sin contenido';
    } else {
      throw Exception('❌ Error al generar evaluación: ${response.body}');
    }
  }

  static Future<String> guardarEvaluacion({
    required List<Map<String, String>> respuestas,
    required String puntoId,
    required String visitaId,
  }) async {
    final body = {
      "cliente": {
        "tipo_negocio": "Cafetería",
        "zona": "Zona Tec",
        "antiguedad_cliente": "2 años",
        "nombre_dueno": "María González",
      },
      "respuestas": respuestas
          .map(
            (r) => {
              "id_pregunta": r["id_pregunta"] ?? '',
              "respuesta": r["respuesta"] ?? '',
            },
          )
          .toList(),
      "colaborador": "Ximena Ortiz",
    };

    final url = Uri.parse(
      '$_baseUrl/guardar-evaluacion?punto_id=$puntoId&visita_id=$visitaId',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['mensaje'] ?? 'Guardado exitoso';
    } else {
      throw Exception('❌ Error al guardar evaluación: ${response.body}');
    }
  }
}
