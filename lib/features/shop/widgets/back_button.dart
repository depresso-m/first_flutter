import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),

            onPressed: () => Navigator.of(context).pop(),

            tooltip: 'Назад',
          ),
        ],
      ),
    );
  }
}
