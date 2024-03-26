//tentativa de fazer a requisição do login

import 'package:http/http.dart';

class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({required this.token, required this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] != null ? json['token'] : '',
      error: json['error'] != null ? json['error'] : '',
    );
  }
}

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email,
      'password': password,
    };
    return map;
  }
}
