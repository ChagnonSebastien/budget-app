import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/pages/transaction_edit.dart';
import 'package:flutter_hello_world/pages/transaction_new.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hello_world/widgets/transaction_card.dart';
import 'package:flutter_hello_world/widgets/transaction_filter_display.dart';
import 'package:flutter_hello_world/widgets/transaction_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyTransactions extends ConsumerWidget {
  MyTransactions({super.key, this.displayDates = true, this.reorderable = false});

  final bool displayDates;
  final bool reorderable;

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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Column(children: [
        TransactionFilterDisplay(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TransactionList(
            displayDates: true,
            reorderable: true,
            filter: (transaction) => transaction.transactionType != TransactionType.initial,
          ),
        ),
      ]),
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
