import 'package:bloc/bloc.dart';
import 'package:first_flutter/bloc_and_cubit/counter/counter_observer.dart';
import 'package:first_flutter/bloc_and_cubit/block_app.dart';
import 'package:flutter/widgets.dart';

void main() {
  Bloc.observer = const CounterObserver();
  runApp(const CounterApp());
}
