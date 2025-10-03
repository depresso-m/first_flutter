import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ФИО СТУДЕНТА",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ЧЕРЕПОВ",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(width: 10),
              Text(
                "МИХАИЛ",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(width: 10),
              Text(
                "БОРИСОВИЧ",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}