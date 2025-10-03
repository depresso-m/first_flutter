import 'package:first_flutter/screens/groupScreen.dart';
import 'package:first_flutter/screens/homeScreen.dart';
import 'package:first_flutter/screens/nameScreen.dart';
import 'package:first_flutter/screens/numberStudScreen.dart';
import 'package:first_flutter/screens/specialityScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Практика №3',
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
    HomeScreen(),
    NameScreen(),
    GroupScreen(),
    NumberStudScreen(),
    SpecialityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Приложение")),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // смена экрана
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: "Имя"),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessible_forward_outlined),
            label: "Группа",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart),
            label: "Номер студ.",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.adb),
            label: "Специальность",
          ),
        ],
      ),
    );
  }
}
