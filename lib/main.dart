import 'package:first_flutter/screens/medReceptionScreen.dart';
import 'package:first_flutter/screens/medicineScreen.dart';
import 'package:first_flutter/screens/stockScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Практика №4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    MedicineScreen(),
    PharmacyStockScreen(),
    MedicineReceptionScreen(),
  ];

  final List<String> _titles = [
    "Каталог лекарств",
    "Количество заказов",
    "Приемка",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: "Каталог",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.warehouse), label: "Склад"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Приемка"),
        ],
      ),
    );
  }
}
