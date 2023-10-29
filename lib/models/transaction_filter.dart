import 'package:flutter_hello_world/models/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_filter.g.dart';

class Filter {
  String category = rootCategoryUid;
  DateTime from = DateTime(DateTime.now().year);
  DateTime to = DateTime.now();
  String? source = null;
  String? destination = null;
  String filter = "";
}

@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  Filter build() {
    return Filter();
  }
}
