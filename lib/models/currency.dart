import 'dart:math';

import 'package:flutter_hello_world/models/savable.dart';
import 'package:flutter_hello_world/persistence/currencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'currency.g.dart';

class Currency extends Savable {
  Currency({
    String? uid,
    required this.name,
    required this.decimals,
    required this.symbol,
    required this.showSymbolBeforeAmount,
  }) {
    this.uid = uid ?? Uuid().v4();
  }

  @override
  late final String uid;

  final String name;
  final int decimals;
  final String symbol;
  final bool showSymbolBeforeAmount;

  String formatNumber(int amount) {
    return (amount / pow(10, decimals)).toStringAsFixed(decimals);
  }

  int parseNumber(String value) {
    return (double.parse(value) * pow(10, decimals)).floor();
  }

  String formatFull(int amount) {
    String prefix = showSymbolBeforeAmount ? '${symbol} ' : '';
    String suffix = showSymbolBeforeAmount ? '' : ' ${symbol}';
    String value = formatNumber(amount);
    return '$prefix$value$suffix';
  }
}

@riverpod
class Currencies extends _$Currencies {
  @override
  Future<Map<String, Currency>> build() async {
    return getAll();
  }

  Future<Map<String, Currency>> getAll() async {
    List<Currency> items = await ref.read(currenciesPersistenceProvider.notifier).readAll();
    return Map.fromEntries(items.map((e) => MapEntry(e.uid, e)));
  }

  Future<void> factoryReset() async {
    await ref.read(currenciesPersistenceProvider.notifier).init();
    await ref.read(currenciesPersistenceProvider.notifier).populateData();
    state = AsyncData(await getAll());
  }
}
