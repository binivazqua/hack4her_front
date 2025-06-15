import 'package:http/http.dart' as http;

class ConfirmacionService {
  static const String _baseUrl =
      'https://b2ef-131-178-102-172.ngrok-free.app'; // actualiza con tu dominio

  static Future<String> confirmarVisita({
    required String puntoId,
    required String visitaId,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/finalizar-visita?punto_id=$puntoId&visita_id=$visitaId',
    );

    final response = await http.post(url);

    if (response.statusCode == 200) {
      return "✅ Visita confirmada";
    } else {
      throw Exception('Error al confirmar visita: ${response.body}');
    }
  }
}
