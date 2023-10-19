import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:flutter_hello_world/persistance/transactions.dart';
import 'package:flutter_hello_world/widgets/transaction_form.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

class Transaction extends Savable {
  Transaction({
    String? uid,
    required this.amount,
    required this.from,
    required this.to,
    required this.date,
    required this.category,
    required this.currency,
    this.note,
  }) {
    this.uid = uid ?? const Uuid().v4();
  }

  @override
  late final String uid;

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

  get amountNumber {
    if (amount == 0) {
      return '';
    }
    return currency.formatNumber(amount);
  }

  get amountFull {
    if (amount == 0) {
      return '';
    }
    return currency.formatFull(amount);
  }
}

@riverpod
class Transactions extends _$Transactions {
  @override
  Future<List<Transaction>> build() async {
    return getAll();
  }

  void newTransaction(Transaction transaction) async {
    await ref.read(transactionsPersistanceProvider.notifier).create(transaction);
    final previousState = await future;
    final newState = [...previousState, transaction];
    newState.sort((a, b) => a.date.compareTo(b.date));
    state = AsyncData(newState);
  }

  void editTransaction(String id, Transaction transaction) async {
    final previousState = await future;
    final newState = previousState.map((e) => e.uid == id ? transaction : e).toList();
    newState.sort((a, b) => a.date.compareTo(b.date));
    state = AsyncData(newState);
  }

  void reorder() async {
    final previousState = await future;
    final newState = [...previousState];
    newState.sort((a, b) => a.date.compareTo(b.date));
    state = AsyncData(newState);
  }

  Future<List<Transaction>> getAll() async {
    final items =  await ref.read(transactionsPersistanceProvider.notifier).readAll();
    items.sort((a, b) => a.date.compareTo(b.date));
    return items;
  }

  Future<Function> factoryReset() async {
    await ref.read(transactionsPersistanceProvider.notifier).deleteAll();

    return () async {
      await ref.read(transactionsPersistanceProvider.notifier).populateData();
      state = AsyncData(await getAll());
    };
  }
}
