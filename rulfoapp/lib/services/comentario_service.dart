import 'dart:convert';
import 'package:http/http.dart' as http;

class ComentarioService {
  static const String _baseUrl =
      'https://absolute-live-sheepdog.ngrok-free.app'; // o tu IP local

  static Future<String> enviarComentario({
    required String comentario,
    required String puntoId,
    required String visitaId,
  }) async {
    final url = Uri.parse(
      '${_baseUrl}/guardar-comentario?comentario_colaborador=${Uri.encodeComponent(comentario)}&punto_id=$puntoId&visita_id=$visitaId',
    );

    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['mensaje'] ?? 'Comentario guardado';
    } else {
      throw Exception('Error al enviar comentario: ${response.body}');
    }
  }
}
