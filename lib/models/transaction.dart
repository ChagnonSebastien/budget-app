import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/persistance/persistance.dart';
import 'package:flutter_hello_world/widgets/transaction_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

class Transaction extends Savable {

  Transaction({
    String? id,
    required this.amount,
    required this.from,
    required this.to,
    required this.date,
    required this.category,
    required this.currency,
    this.note,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  @override
  late final String id;

  int amount;
  Account from;
  Account to;
  DateTime date;
  Category category;
  Currency currency;
  String? note;

  TransactionType get transactionType {
    if (!from.personal) {
      return TransactionType.income;
    } else if (!to.personal) {
      return TransactionType.expense;
    } else {
      return TransactionType.transfer;
    }
  }

  get formattedAmount {
    if (amount == 0) {
      return '';
    }
    return currency.formatValue(amount);
  }
}

@riverpod
class Transactions extends _$Transactions {

  @override
  Future<List<Transaction>> build() async {
    final categories = await ref.watch(categoriesProvider.future);
    return [
      Transaction(
        amount: 325,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.wallet,
        to: Defaults.accounts.starbucks,
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: categories.values.firstWhere((element) => element.name == 'Fast food'),
        note: 'Coffee',
      ),
      Transaction(
        amount: 14689,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.checking,
        to: Defaults.accounts.maxi,
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: categories.values.firstWhere((element) => element.name == 'Groceries'),
      ),
      Transaction(
        amount: 325,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.wallet,
        to: Defaults.accounts.randolph,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: categories.values.firstWhere((element) => element.name == 'Restaurant'),
        note: 'Fete de Pierre',
      ),
      Transaction(
        amount: 1020,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.checking,
        to: Defaults.accounts.viateurBagel,
        date: DateTime.now(),
        category: categories.values.firstWhere((element) => element.name == 'Fast food'),
        note: 'Bagels',
      ),
    ];
  }

  void newTransaction(Transaction transaction) async {
    final previousState = await future;
    final newState = [...previousState, transaction];
    newState.sort((a, b) => a.date.compareTo(b.date));
    state = AsyncData(newState);
  }

  void editTransaction(String id, Transaction transaction) async {
    final previousState = await future;
    final newState = previousState.map((e) => e.id == id ? transaction : e).toList();
    newState.sort((a, b) => a.date.compareTo(b.date));
    state = AsyncData(newState);
  }


}

