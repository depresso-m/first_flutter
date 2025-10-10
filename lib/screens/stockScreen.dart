import 'package:flutter/material.dart';

class PharmacyStockScreen extends StatefulWidget {
  const PharmacyStockScreen({super.key});

  @override
  State<PharmacyStockScreen> createState() => _PharmacyStockScreenState();
}

class _PharmacyStockScreenState extends State<PharmacyStockScreen> {
  final List<Medicine> _medicines = [
    Medicine(name: "Парацетамол", quantity: 120),
    Medicine(name: "Ибупрофен", quantity: 85),
    Medicine(name: "Но-шпа", quantity: 60),
    Medicine(name: "Активированный уголь", quantity: 200),
  ];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  void _addMedicine() {
    final name = _nameController.text.trim();
    final countText = _countController.text.trim();
    final count = int.tryParse(countText) ?? 0;

    if (name.isEmpty || count <= 0) return;

    setState(() {
      _medicines.add(Medicine(name: name, quantity: count));
    });

    _nameController.clear();
    _countController.clear();
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Название лекарства",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _countController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Количество",
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
              child: ListView.builder(
                itemCount: _medicines.length,
                itemBuilder: (context, index) {
                  final medicine = _medicines[index];
                  return MedicineItem(
                    key: ValueKey(medicine.name),
                    medicine: medicine,
                    onRemove: () => _removeMedicine(index),
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

class Medicine {
  String name;
  int quantity;

  Medicine({required this.name, required this.quantity});
}

class MedicineItem extends StatefulWidget {
  final Medicine medicine;
  final VoidCallback onRemove;

  const MedicineItem({
    required Key key,
    required this.medicine,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<MedicineItem> createState() => _MedicineItemState();
}

class _MedicineItemState extends State<MedicineItem> {
  void _increase() {
    setState(() {
      widget.medicine.quantity++;
    });
  }

  void _decrease() {
    setState(() {
      if (widget.medicine.quantity > 0) {
        widget.medicine.quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.medical_services_outlined),
        title: Text(widget.medicine.name),
        subtitle: Text("Количество: ${widget.medicine.quantity} шт."),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: _increase,
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.orange),
              onPressed: _decrease,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
