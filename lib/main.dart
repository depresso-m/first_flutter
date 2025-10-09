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
      home: StatefulListExample(),
    );
  }
}

class SimpleListExmp extends StatelessWidget {
  SimpleListExmp({super.key});

  final items = List.generate(40, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.map((item) => Text(item)).toList(),
      ),
    );
  }
}

class SingleChildScrollExmp extends StatelessWidget {
  SingleChildScrollExmp({super.key});

  final items = List.generate(40, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.map((item) => Text(item)).toList(),
        ),
      ),
    );
  }
}

class ListViewBuilderExmp extends StatelessWidget {
  ListViewBuilderExmp({super.key});

  final items = List.generate(100, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, position) => Text(items[position]),
        itemCount: items.length,
      ),
    );
  }
}

class ListViewSeparatedExmp extends StatelessWidget {
  ListViewSeparatedExmp({super.key});

  final items = List.generate(100, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (_, position) => Text(items[position]),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final items = List.generate(100, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: items
            .map(
              (item) => GestureDetector(
                key: ValueKey(item),
                onTap: () => setState(() => items.remove(item)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(item),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}


// вот этот отражает проблему
class StatefulListExample extends StatefulWidget {
  @override
  _StatefulListExampleState createState() => _StatefulListExampleState();
}

class _StatefulListExampleState extends State<StatefulListExample> {
  List<String> items = ["Item 1", "Item 2", "Item 3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Удаление с состоянием")),
      body: ListView(
        children: items
            .map((item) => CounterWidget(item: item, key : ValueKey(item))) // если убрать ключ то будет возникать ошибка
            .toList(),
      ),
    );
  }
}

// StatefulWidget внутри списка
class CounterWidget extends StatefulWidget {
  final String item;

  CounterWidget({required this.item, Key? key}) : super(key: key); // Передаём ключ в супер.

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${widget.item}: $counter'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => counter++),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Удаляем элемент из списка родителя
              final parentState = context.findAncestorStateOfType<_StatefulListExampleState>();
              parentState?.setState(() => parentState.items.remove(widget.item));
            },
          ),
        ],
      ),
    );
  }
}
