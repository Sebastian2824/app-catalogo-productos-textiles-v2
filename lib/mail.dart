import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> enviarPedidoPorEmail({
  required String userName,
  required String userEmail,
  required String pedidosGorras,
  required String pedidosPantalones,
  required String pedidosTelas,
}) async {
  const serviceId = 'service_zv1fo9j';
  const templateId = 'template_9y049qc';
  const publicKey = 'NvW26g4Z-OirvEWEM'; // Lo obtienes desde EmailJS dashboard

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost', // necesario para evitar error de CORS
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'template_params': {
        'user_name': userName,
        'user_email': userEmail,
        'pedidos_gorras': pedidosGorras,
        'pedidos_pantalones': pedidosPantalones,
        'pedidos_telas': pedidosTelas,
      },
    }),
  );

  if (response.statusCode == 200) {
    print('✅ Pedido enviado con éxito');
  } else {
    print('❌ Error al enviar pedido: ${response.body}');
  }
}
