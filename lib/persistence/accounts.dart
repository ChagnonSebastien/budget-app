import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/persistence/persistence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'accounts.g.dart';

String LABEL_ACCOUNTS = "Accounts";
String _LABEL_NAME = "name";
String _LABEL_INITIAL_AMOUNT = "initialAmount";
String _LABEL_PERSONAL = "personal";

@Riverpod(keepAlive: true)
class AccountsPersistence extends _$AccountsPersistence with Crud<Account> {
  @override
  Future<Database> build() => ref.watch(databaseProvider.future);

  @override
  String getTableName() => LABEL_ACCOUNTS;

  @override
  Map<String, dynamic> toJson(Account element) {
    return {
      LABEL_UID: element.uid,
      _LABEL_NAME: element.name,
      _LABEL_INITIAL_AMOUNT: element.initialAmount,
      _LABEL_PERSONAL: element.personal ? 1 : 0,
    };
  }

  @override
  Future<Account> fromJson(Map<String, dynamic> json) async {
    return Account(
        uid: json[LABEL_UID],
        name: json[_LABEL_NAME],
        initialAmount: json[_LABEL_INITIAL_AMOUNT],
        personal: json[_LABEL_PERSONAL] == 1);
  }

  @override
  Future<void> init() async {
    final db = await future;
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $LABEL_ACCOUNTS (
          $LABEL_UID VARCHAR(36) NOT NULL ,
          $_LABEL_NAME VARCHAR(255) NOT NULL,
          $_LABEL_INITIAL_AMOUNT INT NOT NULL,
          $_LABEL_PERSONAL BOOLEAN NOT NULL,
          PRIMARY KEY ($LABEL_UID)
        );
      ''');

  }
  
  @override
  Future<void> populateData() async {
    await Future.wait(Defaults.accounts.asList().map((e) => create(e)));
  }
}
