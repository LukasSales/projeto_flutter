import 'package:flutter/material.dart';

class backgroundFiltro extends StatelessWidget {
  const backgroundFiltro({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF152292).withOpacity(0.8),
            Color(0xFF7EF0FF).withOpacity(0.8),
            Color(0xFF7EF0FF).withOpacity(0.8),
          ],
        ),
      ),
    );
  }
}
