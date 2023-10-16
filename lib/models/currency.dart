import 'package:flutter_hello_world/persistance/persistance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency.g.dart';

class Currency extends Savable {
  Currency({
    required this.name,
    required this.decimals,
    required this.symbol,
    required this. showSymbolBeforeAmount,
  });

  @override
  String get id => name;

  final String name;
  final int decimals;
  final String symbol;
  final bool showSymbolBeforeAmount;
}

Currency cad = Currency(name: 'CAD', decimals: 2, symbol: '\$', showSymbolBeforeAmount: true);
Currency aapl = Currency(name: 'Apple Share', decimals: 4, symbol: 'AAPL', showSymbolBeforeAmount: false);


@riverpod
Future<Currency> currency(CurrencyRef ref, String id) async {
  return cad;
}
