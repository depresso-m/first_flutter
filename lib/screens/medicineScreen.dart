import 'package:flutter/material.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _PopularMedicinesScreenState();
}

class _PopularMedicinesScreenState extends State<MedicineScreen> {
  final List<String> _medicines = [
    "Парацетамол",
    "Ибупрофен",
    "Но-шпа",
    "Активированный уголь",
  ];

  final TextEditingController _controller = TextEditingController();

  void _addMedicine() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _medicines.add(text);
      });
      _controller.clear();
    }
  }

  void _removeMedicine(int index) {
    setState(() {
      _medicines.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Название лекарства",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addMedicine,
                  child: const Text("Добавить"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(_medicines.length, (index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.medication),
                        title: Text(_medicines[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeMedicine(index),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
