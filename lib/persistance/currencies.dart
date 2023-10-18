import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/persistance/persistance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'currencies.g.dart';

String LABEL_TABLE_CURRENCIES = "Currencies";
String _LABEL_NAME = "name";
String _LABEL_DECIMALS = "decimals";
String _LABEL_SYMBOL = "symbol";
String _LABEL_SHOW_SYMBOL_BEFORE_AMOUNT = "showSymbolBeforeAmount";

@Riverpod(keepAlive: true)
class CurrenciesPersistance extends _$CurrenciesPersistance with Crud<Currency> {
  @override
  Future<Database> build() => ref.watch(databaseProvider.future);

  @override
  String getTableName() => LABEL_TABLE_CURRENCIES;

  @override
  Map<String, dynamic> toJson(Currency element) {
    return {
      LABEL_UID: element.uid,
      _LABEL_NAME: element.name,
      _LABEL_DECIMALS: element.decimals,
      _LABEL_SYMBOL: element.symbol,
      _LABEL_SHOW_SYMBOL_BEFORE_AMOUNT: element.showSymbolBeforeAmount ? 1 : 0
    };
  }

  @override
  Future<Currency> fromJson(Map<String, dynamic> json) async {
    return Currency(
        uid: json[LABEL_UID],
        name: json[_LABEL_NAME],
        decimals: json[_LABEL_DECIMALS],
        symbol: json[_LABEL_SYMBOL],
        showSymbolBeforeAmount: json[_LABEL_SHOW_SYMBOL_BEFORE_AMOUNT] == 1);
  }

  @override
  Future<void> init() async {
    final db = await future;
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $LABEL_TABLE_CURRENCIES (
          $LABEL_UID VARCHAR(36) NOT NULL ,
          $_LABEL_NAME VARCHAR(255) NOT NULL,
          $_LABEL_DECIMALS TINYINT NOT NULL,
          $_LABEL_SYMBOL VARCHAR(63) NOT NULL,
          $_LABEL_SHOW_SYMBOL_BEFORE_AMOUNT BOOLEAN NOT NULL,
          PRIMARY KEY ($LABEL_UID)
        );
      ''');

    await Future.wait(Defaults.currencies.asList().map((e) => create(e)));
  }
}
