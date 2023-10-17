import 'dart:math';

import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency.g.dart';

class Currency extends Savable {
  Currency({
    required this.name,
    required this.decimals,
    required this.symbol,
    required this.showSymbolBeforeAmount,
  });

  @override
  String get uid => name;

  final String name;
  final int decimals;
  final String symbol;
  final bool showSymbolBeforeAmount;

  String formatValue(int amount) {
    String prefix = showSymbolBeforeAmount ? '${symbol} ' : '';
    String suffix = showSymbolBeforeAmount ? '' : ' ${symbol}';
    String value = (amount / pow(10, decimals)).toStringAsFixed(decimals);
    return '$prefix$value$suffix';
  }
}

@riverpod
class Currencies extends _$Currencies {
  @override
  Future<List<Currency>> build() async {
    return Defaults.currencies.asList();
  }
}
