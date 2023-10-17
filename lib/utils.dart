import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool sameDay(DateTime a, DateTime b) {
  if (a.year != b.year) return false;
  if (a.month != b.month) return false;
  if (a.day != b.day) return false;
  return true;
}

extension DateFormatingExtension on DateTime {
  String toDate() {
    String s = DateFormat.yMMMMd().format(this);
    return s;
  }

  DateTime trimToDay() {
    return DateTime(year, month, day);
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

Widget dragDecorator(Widget child, int _, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      final double animValue = Curves.easeInOut.transform(animation.value);
      final double scale = lerpDouble(1, 1.02, animValue)!;
      return Transform.scale(scale: scale, child: child);
    },
    child: child,
  );
}
