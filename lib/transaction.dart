import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hello_world/account.dart';
import 'package:flutter_hello_world/category.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class Transaction with UniqueID {

  Transaction({
    required this.name,
    required this.amount,
    required this.from,
    required this.to,
    required this.date,
    required this.category,
  });

  String name;
  int amount;
  Account from;
  Account to;
  DateTime date;
  Category category;
}


class TransactionManager extends StateNotifier<List<Transaction>> {
  TransactionManager([List<Transaction>? initialTransactions]) : super(initialTransactions ?? []);

  void newTransaction(Transaction transaction) {
    state = [
      ...state,
      transaction,
    ];
  }

  void reorder() {
    state.sort((a, b) => b.date.compareTo(a.date));
    state = [...state];
  }


}


final transactionsNotifierProvider = StateNotifierProvider<TransactionManager, List<Transaction>>((ref) {
  var initialTransactions = [
    Transaction(
      name: 'Coffee',
      amount: 325,
      from: wallet,
      to: starbucks,
      date: DateTime.now(),
      category: fastFood,
    ),
    Transaction(
      name: 'Bagels',
      amount: 1020,
      from: wallet,
      to: viateurBagel,
      date: DateTime(2023, 09, 11),
      category: groceries,
    ),
  ];
  return TransactionManager(initialTransactions);
});





class TransactionCard extends StatelessWidget  {
  const TransactionCard({
    super.key,
    required this.transaction,
    this.textSize = 11,
  });
  
  final Transaction transaction;
  final double textSize;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              transaction.category.iconData,
              color: transaction.category.iconColor,
              size: textSize * 2.8,
            ),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.name,
                style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w700),
              ),
              Text(
                '\$ ${(transaction.amount / pow(10, transaction.from.currency.decimals)).toStringAsFixed(transaction.from.currency.decimals)}',
                style: TextStyle(fontSize: textSize),
              ),
            ],
          )),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'From: ',
                  style: TextStyle(fontSize: textSize),
                ),
                Text(
                  'To: ',
                  style: TextStyle(fontSize: textSize),
                ),
              ],
            ),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.from.name,
                style: TextStyle(fontSize: textSize),
              ),
              Text(
                transaction.to.name,
                style: TextStyle(fontSize: textSize),
              ),
            ],
          )),
        ],
      ),
    ),
  );
}
