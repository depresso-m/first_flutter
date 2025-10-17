import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyPlaceholder({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outline;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: color),
          SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
