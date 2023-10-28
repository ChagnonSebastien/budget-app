import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:flutter_hello_world/persistence/transactions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

enum TransactionType {
  expense(mustBeFromMine: true, mustBeToMine: false),
  income(mustBeFromMine: false, mustBeToMine: true),
  transfer(mustBeFromMine: true, mustBeToMine: true),
  initial(mustBeFromMine: false, mustBeToMine: true);

  const TransactionType({required this.mustBeFromMine, required this.mustBeToMine});

  final bool mustBeFromMine;
  final bool mustBeToMine;
}

class Transaction extends Savable {
  Transaction({
    String? uid,
    required this.amount,
    this.from,
    required this.to,
    required this.date,
    this.category,
    required this.currency,
    this.note,
  }) {
    this.uid = uid ?? const Uuid().v4();
  }

  @override
  late final String uid;

  int amount;
  Account? from;
  Account to;
  DateTime date;
  Category? category;
  Currency currency;
  String? note;

  TransactionType get transactionType {
    if (from == null) {
      return TransactionType.initial;
    }
    if (!from!.personal) {
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
    await ref.read(transactionsPersistenceProvider.notifier).create(transaction);
    final previousState = await future;
    final newState = [...previousState, transaction];
    newState.sort((a, b) => a.date.compareTo(b.date));
    state = AsyncData(newState);
  }

  void editTransaction(Transaction transaction) async {
    await ref.read(transactionsPersistenceProvider.notifier).updateElement(transaction);

    final previousState = await future;
    final newState = previousState.map((e) => e.uid == transaction.uid ? transaction : e).toList();
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
    final items = await ref.read(transactionsPersistenceProvider.notifier).readAll();
    items.sort((a, b) => a.date.compareTo(b.date));
    return items;
  }

  Future<void> factoryReset() async {
    await ref.read(transactionsPersistenceProvider.notifier).init();
    await ref.read(transactionsPersistenceProvider.notifier).populateData();
    state = AsyncData(await getAll());
  }
}
