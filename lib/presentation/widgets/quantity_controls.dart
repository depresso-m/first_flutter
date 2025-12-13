import 'package:flutter/material.dart';

class QuantityControls extends StatelessWidget {
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final String quantityText;

  const QuantityControls({
    super.key,
    required this.onDecrement,
    required this.onIncrement,
    required this.quantityText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onDecrement,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        ),
        const SizedBox(width: 4),
        Text(quantityText),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: onIncrement,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
        ),
      ],
    );
  }
}
