import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_filter.g.dart';

const thisYear = "This Year";
const thisMonth = "This Month";
const lastYear = "Last Year";
const lastMonth = "Last Month";
const customRange = "Custom Range";

const dateFilterOptions = [thisMonth, thisYear, lastMonth, lastYear, customRange];

class Filter {
  String category = rootCategoryUid;
  DateTime from = DateTime(DateTime.now().year);
  DateTime to = DateTime.now();
  String? source = null;
  String? destination = null;
  String filter = "";

  get dateFilterType {
    final today = DateTime.now();

    if (!sameDay(today, to)) return customRange;
    if (sameDay(DateTime(today.year), from)) return thisYear;
    if (sameDay(DateTime(today.year, today.month), from)) return thisMonth;
    if (sameDay(today.copyWith(year: today.year - 1), from)) return lastYear;
    if (sameDay(today.copyWith(month: today.month - 1), from)) return lastMonth;

    return customRange;
  }
}

@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  Filter build() {
    return Filter();
  }
}
