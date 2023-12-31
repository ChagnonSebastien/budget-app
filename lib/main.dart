import 'package:flutter/material.dart';
import 'package:flutter_hello_world/pages/home.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: BudgetApp(),
  ));
}

class BudgetApp extends HookWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.teal,
          background: Color.fromARGB(255, 245, 245, 245),
        ),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
