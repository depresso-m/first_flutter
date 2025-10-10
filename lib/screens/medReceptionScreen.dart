import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineReceptionScreen extends StatefulWidget {
  const MedicineReceptionScreen({super.key});

  @override
  State<MedicineReceptionScreen> createState() =>
      _MedicineReceptionScreenState();
}

class _MedicineReceptionScreenState extends State<MedicineReceptionScreen> {
  final List<Map<String, String>> _records = [];
  final TextEditingController _controller = TextEditingController();

  void _addRecord() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final now = DateTime.now();
    final formatted = DateFormat('HH:mm dd.MM.yyyy').format(now);

    setState(() {
      _records.add({'name': name, 'time': formatted});
    });

    _controller.clear();
  }

  void _removeRecord(int index) {
    setState(() {
      _records.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                  onPressed: _addRecord,
                  child: const Text("Добавить"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: _records.length,
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  final record = _records[index];
                  return Card(
                    key: ValueKey(record['time']),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(record['name'] ?? ''),
                      subtitle: Text("Принято: ${record['time']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeRecord(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
