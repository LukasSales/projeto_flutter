import 'package:flutter/material.dart';

class backgroundImagem extends StatelessWidget {
  const backgroundImagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/fundo.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
