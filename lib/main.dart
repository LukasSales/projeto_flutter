import 'package:flutter/material.dart';
import 'package:flutter_projeto_live/telas/tela_01.dart';
import 'package:flutter_projeto_live/telas/tela_02.dart'; // Importe a tela 02 aqui

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'tela_01', // Defina a rota inicial para TelaLogin
      routes: {
        'tela_01': (context) => TelaLogin(), // Rota para TelaLogin
        'tela_02': (context) => TelaPerfil(), // Rota para Tela02
      },
    );
  }
}
