//tentativa de fazer os serviços da api

import 'package:flutter_projeto_live/models/login_modelo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIservice {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    var headers = {
      'User-Agent': 'Apidog/1.0.0 (https://apidog.com)',
      'Content-Type': 'Application/Json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://digital-aligner.ddns.net:3000/login'));
    request.body = jsonEncode(
        {"email": requestModel.email, "password": requestModel.password});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Parse response and return appropriate LoginResponseModel
      return LoginResponseModel.fromJson(
          json.decode(await response.stream.bytesToString()));
    } else {
      // Handle error scenario
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }
}
