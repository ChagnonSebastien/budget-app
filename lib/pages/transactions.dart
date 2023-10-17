import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/pages/edit_transaction.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hello_world/widgets/transaction_form.dart';
import 'package:flutter_hello_world/widgets/transaction_card.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/pages/new_transaction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyTransactions extends ConsumerWidget {
  MyTransactions({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    if (!transactions.hasValue) {
      return Loading();
    }

    List<Widget> items = [];
    List<DateTime> itemDates = [];
    DateTime? lastDay;

    for (Transaction t in transactions.value!.reversed) {
      bool newDay = lastDay == null || !sameDay(t.date, lastDay);
      if (newDay) {
        DateTime currentDate = t.date.trimToDay();
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

      items.add(GestureDetector(
          key: Key(t.uid),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditTransaction(
                transaction: t,
              );
            }));
          },
          child: TransactionCard(
            transaction: t,
          )));
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
          final Widget gestureDetector = items[oldIndex];
          if (gestureDetector is! GestureDetector) return;
          final Widget movedCard = gestureDetector.child!;
          if (movedCard is! TransactionCard) return;

          var beforeElementDate =
              newIndex == itemDates.length ? itemDates[newIndex - 1].trimToDay() : itemDates[newIndex];
          var afterElementDate =
              newIndex == 0 ? beforeElementDate.add(const Duration(days: 1)) : itemDates[newIndex - 1];

          if (!sameDay(beforeElementDate, afterElementDate.subtract(const Duration(seconds: 1)))) {
            beforeElementDate = afterElementDate.trimToDay();
          }

          var halfTimeDiff = (afterElementDate.difference(beforeElementDate).inMicroseconds / 2).round();
          var newDate = beforeElementDate.add(Duration(microseconds: halfTimeDiff));
          movedCard.transaction.date = newDate;
          ref.read(transactionsProvider.notifier).reorder();
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
