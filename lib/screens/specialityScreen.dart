import 'package:flutter/material.dart';

class SpecialityScreen extends StatelessWidget {
  const SpecialityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Моя специальность",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text(
            "ПРОГРАММНАЯ ИНЖЕНЕРИЯ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.purple),
          ),
        ],
      ),
    );
  }
}