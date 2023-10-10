
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/edit_transaction.dart';
import 'package:flutter_hello_world/widgets/transaction_card.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/pages/new_transaction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyTransactions extends ConsumerWidget {
  MyTransactions({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsNotifier = ref.watch(transactionsProvider.notifier);
    final transactions = ref.watch(transactionsProvider);

    List<Widget> items = [];
    List<DateTime> itemDates = [];
    DateTime? lastDay;


    for (Transaction t in transactions.reversed) {
      bool newDay = lastDay == null || !sameDay(t.date, lastDay);
      if (newDay) {
        DateTime currentDate = DateTime(t.date.year, t.date.month, t.date.day);
        items.add(GestureDetector(
          onLongPress: () {
            // Do nothing. Prevents the re-ordering of date labels.
          },
          key: Key(t.date.toIso8601String()),
          child: Text(
            currentDate.toDate(),
            textAlign: TextAlign.center,
          ),
        ));
        itemDates.add(currentDate.add(const Duration(days: 1)));
        lastDay = currentDate;
      }
      
      items.add(TransactionCard(
        key: Key(t.id),
        transaction: t,
      ));
      itemDates.add(t.date);
    }


    return Scaffold(
      key: scaffoldKey,
      body: ReorderableListView(
        padding: const EdgeInsets.all(10),
        proxyDecorator: dragDecorator,
        shrinkWrap: true,
        children: items,
        onReorder: (oldIndex, newIndex) {
          final Widget movedCard = items[oldIndex];
          if (movedCard is! TransactionCard) return;

          var previousDay = DateTime(itemDates[newIndex - 1].year, itemDates[newIndex - 1].month, itemDates[newIndex - 1].day);
          var beforeElementDate = newIndex == itemDates.length ? previousDay : itemDates[newIndex];
          var afterElementDate = newIndex == 0 ? beforeElementDate.add(const Duration(days: 1)) : itemDates[newIndex - 1];

          if (!sameDay(beforeElementDate, afterElementDate.subtract(const Duration(seconds: 1)))) {
            beforeElementDate = DateTime(afterElementDate.year, afterElementDate.month, afterElementDate.day);
          }

          var newDate = beforeElementDate.add(Duration(microseconds: (afterElementDate.difference(beforeElementDate).inMicroseconds / 2).round()));
          movedCard.transaction.date = newDate;

          transactionsNotifier.reorder();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NewTransaction(
              transactionType: TransactionType.expense,
            );
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
