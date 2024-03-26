import 'package:flutter/material.dart';
import 'package:flutter_projeto_live/widgets/backgroundFiltro.widgets.dart';
import 'package:flutter_projeto_live/widgets/backgroundImagem.widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

void realizarLogin(BuildContext context) async {
  String email = emailController.text;
  String password = passwordController.text;

  // Verificar se os campos de e-mail e senha estão preenchidos
  if (email.isEmpty || password.isEmpty) {
    print('Por favor, preencha todos os campos.');
    return;
  }

  // Construindo o corpo da solicitação JSON
  var body = {
    'email': email,
    'password': password,
  };

  try {
    // Fazendo a solicitação HTTP
    var response = await http.post(
      Uri.parse('http://digital-aligner.ddns.net:3000/login'),
      headers: {
        'User-Agent': 'Apidog/1.0.0 (https://apidog.com)',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    // Verificando o status da resposta
    if (response.statusCode == 200) {
      // Login bem-sucedido, você pode navegar para a próxima tela
      Navigator.pushReplacementNamed(context, 'tela_02');
    } else {
      // Exibindo uma mensagem de erro em caso de falha no login
      print('Falha no login: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Exibindo uma mensagem de erro em caso de exceção
    print('Erro ao realizar login: $e');
  }
}

class _TelaLoginState extends State<TelaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background com imagem de fundo
          const backgroundImagem(),
          // Filtro opaco com degradê
          const Positioned.fill(
            child: backgroundFiltro(),
          ),
          // Conteúdo da tela
          Center(
            child: Container(
              width: 360,
              height: 360,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          child: Image.asset(
                            "assets/🦆 emoji _waving hand_.png",
                            width: 32,
                            height: 32,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: Text(
                            'Bem-vindo (a)',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 38,
                              color: Color(0xFF54C8E8),
                              height: 51.56 / 44,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email@gmail.com',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Positioned(
                          top: -08,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            color: Colors.white,
                            child: const Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: '********',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Positioned(
                          top: -08,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            color: Colors.white,
                            child: const Text(
                              'Senha',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        realizarLogin(context);
                      },
                      child: Text(
                        'Entrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(322, 60),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        side: const BorderSide(
                            color: Color(0xFF0074FF), width: 1),
                        backgroundColor: const Color(0xFF0074FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
