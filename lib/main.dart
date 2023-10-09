import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hello_world/new_transaction.dart';
import 'package:flutter_hello_world/transaction.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: BudgetApp()));
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyTransactions(title: 'Transactions'),
    );
  }
}

class MyTransactions extends StatefulHookConsumerWidget {
  const MyTransactions({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyTransactions> createState() => _MyTransactionsState();
}

class _MyTransactionsState extends ConsumerState<MyTransactions> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final transactionsNotifier = ref.watch(transactionsProvider.notifier);
    final transactions = ref.watch(transactionsProvider);

    List<Widget> items = [];
    List<DateTime> itemDates = [];
    DateTime? lastDay;

    for (Transaction t in transactions) {
      bool newDay = lastDay == null || !sameDay(t.date, lastDay);
      if (newDay) {
        DateTime currentDate = DateTime(t.date.year, t.date.month, t.date.day);
        items.add(GestureDetector(
          onLongPress: () {
            // Do nothing. Prevents the re-ordering of date labels.
          },
          key: Key(t.date.toIso8601String()),
          child: Text(
            format(currentDate),
            textAlign: TextAlign.center,
          ),
        ));
        itemDates.add(currentDate.add(Duration(days: 1)));
        lastDay = currentDate;
      }
      
      items.add(TransactionCard(
        key: Key(t.id),
        transaction: t
      ));
      itemDates.add(t.date);
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(10),
        proxyDecorator: (Widget child, int _, Animation<double> animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget? child) {
              final double animValue = Curves.easeInOut.transform(animation.value);
              final double scale = lerpDouble(1, 1.02, animValue)!;
              return Transform.scale(scale: scale, child: child);
            },
            child: child,
          );
        },
        shrinkWrap: true,
        children: items,
        onReorder: (oldIndex, newIndex) {
          final Widget movedCard = items[oldIndex];
          if (movedCard is! TransactionCard) return;

          var beforeElementDate = newIndex == itemDates.length ? DateTime(itemDates[newIndex - 1].year, itemDates[newIndex - 1].month, itemDates[newIndex - 1].day) : itemDates[newIndex];
          var afterElementDate = newIndex == 0 ? beforeElementDate.add(const Duration(days: 1)) : itemDates[newIndex - 1];

          if (!sameDay(beforeElementDate, afterElementDate.subtract(Duration(seconds: 1)))) {
            beforeElementDate = DateTime(afterElementDate.year, afterElementDate.month, afterElementDate.day);
          }
          var newDate = beforeElementDate.add(Duration(microseconds: (afterElementDate.difference(beforeElementDate).inMicroseconds / 2).round()));
          movedCard.transaction.date = newDate;

          transactionsNotifier.reorder();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context)  => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              child: SingleChildScrollView(
                child: NewTransaction(commit: (transaction) {
                  transactionsNotifier.newTransaction(transaction);
                  transactionsNotifier.reorder();
                  Navigator.pop(context);
                }),
              )
            ),
            enableDrag: true,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
