import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificacionController extends GetxController {
  String baseUrl =
      "https://us-central1-nuestrahistoria-2f33c.cloudfunctions.net/api/enviarNotificaciones";

  Future<void> sendNoti() async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'da1b7d49-5545-450b-9f9c-b226a7aa0e61',
      };

      Map<String, dynamic> body = {
        "tokens":
            "d0uMPk9xQ7-Fa46NJjcVnr:APA91bEwUfP5LRwaA2S4c-WrGWGO61SvGZ8Y9bpbwO1jk3S5Gje4FH4CXU5HrFIILFdcdab-JBxGpUZncHa48AydfHWhXmWZzueUfJSkdfamIyRp2V-dDEZ-yS4XSFGaWFrBhy9fHBkg",
        "mensaje": "Hola mensaje",
        "tituloNoti": "Hola Titulo",
      };

      var response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );
      print(response);
    } catch (error) {
      rethrow;
    }
  }
}
