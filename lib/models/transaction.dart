import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class Transaction with UniqueID {

  Transaction({
    required this.amount,
    required this.from,
    required this.to,
    required this.date,
    required this.category,
    this.note,
  });

  int amount;
  Account from;
  Account to;
  DateTime date;
  Category category;
  String? note;
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
    state.sort((a, b) => a.date.compareTo(b.date));
    state = [...state];
  }


}


final transactionsProvider = StateNotifierProvider<TransactionManager, List<Transaction>>((ref) {
  var initialTransactions = [
    Transaction(
      amount: 325,
      from: wallet,
      to: starbucks,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: fastFood,
      note: 'Coffee',
    ),
    Transaction(
      amount: 14689,
      from: checking,
      to: maxi,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: groceries,
    ),
    Transaction(
      amount: 325,
      from: wallet,
      to: randolph,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: goingOut,
      note: 'Fete de Pierre',
    ),
    Transaction(
      amount: 1020,
      from: checking,
      to: viateurBagel,
      date: DateTime.now(),
      category: groceries,
      note: 'Bagels',
    ),
  ];
  return TransactionManager(initialTransactions);
});

