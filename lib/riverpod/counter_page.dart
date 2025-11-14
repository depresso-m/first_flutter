import 'package:first_flutter/riverpod/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(child: Text('${ref.watch(counterProvider)}')),
      floatingActionButton: FloatingActionButton(
        // The read method is a utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
