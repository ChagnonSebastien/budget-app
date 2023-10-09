import 'package:uuid/uuid.dart';


mixin UniqueID {
  final String id = const Uuid().v4();
}



bool sameDay(DateTime a, DateTime b) {
  if (a.year != b.year) return false;
  if (a.month != b.month) return false;
  if (a.day != b.day) return false;
  return true;
}

String format(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}