import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/pages/transaction_edit.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hello_world/widgets/transaction_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionList extends ConsumerWidget {
  TransactionList({super.key, this.displayDates = true, this.reorderable = false, required this.filter});

  final bool displayDates;
  final bool reorderable;
  final bool Function(Transaction transaction) filter;

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

    final filteredTransactions = transactions.value!.where(filter).toList();

    for (Transaction t in filteredTransactions.reversed) {
      bool newDay = lastDay == null || !sameDay(t.date, lastDay);
      if (newDay) {
        DateTime currentDate = t.date.trimToDay();
        items.add(displayDates
            ? GestureDetector(
                onLongPress: () {
                  // Do nothing. Prevents the re-ordering of date labels.
                },
                key: Key(t.date.toIso8601String()),
                child: Text(
                  currentDate.toDate(),
                  textAlign: TextAlign.center,
                ),
              )
            : Container(key: Key(t.date.toIso8601String())));
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

    return reorderable
        ? ReorderableListView(
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
          )
        : ListView(
            children: items,
            shrinkWrap: true,
          );
  }
}
