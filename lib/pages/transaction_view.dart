import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/models/transaction_filter.dart';
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
    final categories = ref.watch(categoriesProvider);
    final transactionsFilter = ref.watch(transactionFilterProvider);

    if (!transactions.hasValue || !categories.hasValue) {
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
            reorderable: true,
            filter: (transaction) {
              if (transaction.transactionType == TransactionType.initial) {
                return false;
              }

              if (transactionsFilter.source != null &&
                  (transaction.from == null || transactionsFilter.source != transaction.from!.uid)) {
                return false;
              }
              if (transactionsFilter.destination != null && transactionsFilter.destination != transaction.to.uid) {
                return false;
              }
              if (transactionsFilter.filter != "" &&
                  !(transaction.note ?? "").toLowerCase().contains(transactionsFilter.filter.toLowerCase()) &&
                  !(transaction.category?.name ?? "").toLowerCase().contains(transactionsFilter.filter.toLowerCase()) &&
                  !(transaction.from?.name ?? "").toLowerCase().contains(transactionsFilter.filter.toLowerCase()) &&
                  !transaction.to.name.toLowerCase().contains(transactionsFilter.filter.toLowerCase())) {
                return false;
              }

              if (transactionsFilter.category == rootCategoryUid) {
                return true;
              }

              var category = transaction.category!.uid;
              while (category != rootCategoryUid) {
                if (category == transactionsFilter.category) {
                  return true;
                }
                category = categories.value![category]!.parent!;
              }

              return false;
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NewTransaction(
              transactionType: TransactionType.expense,
            );
          }));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
