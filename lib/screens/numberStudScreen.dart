import 'package:flutter/material.dart';

class NumberStudScreen extends StatelessWidget {
  const NumberStudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Номер моего студенческого",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text(
            "22И1849",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.cyan),
          ),
        ],
      ),
    );
  }
}