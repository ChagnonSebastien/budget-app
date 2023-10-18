import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_hello_world/models/valid_icon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'material_icon_data.g.dart';

@riverpod
Future<List<ValidIcon>> materialIconData(MaterialIconDataRef ref) async {
  String data = await rootBundle.loadString('assets/iconMetadata.json');
  List<Map<String, dynamic>> icons = List<Map<String, dynamic>>.from(jsonDecode(data));
  List<ValidIcon> validIcons = icons
      .map((icon) => ValidIcon(
            searchFields: List<String>.from(icon['tags']),
            codepoint: int.parse(icon['codepoint'].substring(2), radix: 16),
          ))
      .toList();
  ref.keepAlive();
  return validIcons;
}