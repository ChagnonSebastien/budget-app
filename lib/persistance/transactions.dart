import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/persistance/accounts.dart';
import 'package:flutter_hello_world/persistance/categories.dart';
import 'package:flutter_hello_world/persistance/currencies.dart';
import 'package:flutter_hello_world/persistance/persistance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart' as sql;

part 'transactions.g.dart';

String LABEL_TRANSACTIONS = "Transactions";
String _LABEL_AMOUNT = "amount";
String _LABEL_CURRENCY = "currency";
String _LABEL_FROM_ACCOUNT = "from_account";
String _LABEL_TO_ACCOUNT = "to_account";
String _LABEL_DATE = "date";
String _LABEL_CATEGORY = "category";
String _LABEL_NOTE = "note";

@Riverpod(keepAlive: true)
class TransactionsPersistance extends _$TransactionsPersistance with Crud<Transaction> {
  @override
  Future<sql.Database> build() => ref.watch(databaseProvider.future);

  @override
  String getTableName() => LABEL_TRANSACTIONS;

  @override
  Map<String, dynamic> toJson(Transaction element) {
    return {
      LABEL_UID: element.uid,
      _LABEL_AMOUNT: element.amount,
      _LABEL_CURRENCY: element.currency.uid,
      _LABEL_FROM_ACCOUNT: element.from.uid,
      _LABEL_TO_ACCOUNT: element.to.uid,
      _LABEL_DATE: element.date.microsecondsSinceEpoch,
      _LABEL_CATEGORY: element.category.uid,
      _LABEL_NOTE: element.note,
    };
  }

  @override
  Future<Transaction> fromJson(Map<String, dynamic> json) async {
    final categories = await ref.read(categoriesProvider.future);
    final currencies = await ref.read(currenciesProvider.future);
    final accounts = await ref.read(accountsProvider.future);

    return Transaction(
      uid: json[LABEL_UID],
      amount: json[_LABEL_AMOUNT],
      from: accounts[json[_LABEL_FROM_ACCOUNT]]!,
      to: accounts[json[_LABEL_TO_ACCOUNT]]!,
      date: DateTime.fromMicrosecondsSinceEpoch(json[_LABEL_DATE]),
      category: categories[json[_LABEL_CATEGORY]]!,
      currency: currencies[json[_LABEL_CURRENCY]]!,
      note: json[_LABEL_NOTE],
    );
  }

  @override
  Future<void> init() async {
    final db = await future;
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $LABEL_TRANSACTIONS (
          $LABEL_UID VARCHAR(36) NOT NULL ,
          $_LABEL_AMOUNT INT NOT NULL,
          $_LABEL_DATE INT NOT NULL,
          $_LABEL_NOTE VARCHAR(255),
          $_LABEL_CURRENCY VARCHAR(36) NOT NULL,
          $_LABEL_FROM_ACCOUNT VARCHAR(36) NOT NULL,
          $_LABEL_TO_ACCOUNT VARCHAR(36) NOT NULL,
          $_LABEL_CATEGORY VARCHAR(36) NOT NULL,
          PRIMARY KEY ($LABEL_UID),
          FOREIGN KEY ($_LABEL_CURRENCY) REFERENCES $LABEL_TABLE_CURRENCIES($LABEL_UID),
          FOREIGN KEY ($_LABEL_FROM_ACCOUNT) REFERENCES $LABEL_ACCOUNTS($LABEL_UID),
          FOREIGN KEY ($_LABEL_TO_ACCOUNT) REFERENCES $LABEL_ACCOUNTS($LABEL_UID),
          FOREIGN KEY ($_LABEL_CATEGORY) REFERENCES $LABEL_CATEGORIES($LABEL_UID)
        );
      ''');

    await Future.wait(Defaults.transactions.asList().map((e) => create(e)));
  }
}
