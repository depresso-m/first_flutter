import 'package:flutter/material.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Группа в которой я учусь",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text(
            "ИКБО-11-22",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
        ],
      ),
    );
  }
}