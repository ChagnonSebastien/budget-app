import 'package:flutter/material.dart';
import 'package:flutter_hello_world/home.dart';
import 'package:flutter_hello_world/transactions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: BudgetApp()));
}


class BudgetApp extends HookWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {

    final selectedPageIndex = useState(0);

    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

