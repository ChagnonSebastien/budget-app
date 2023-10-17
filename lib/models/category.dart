import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:flutter_hello_world/persistance/categories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

final String rootCategoryUid = "830472ff-c3fa-4a38-9e2d-d3f4b4e1268a";

class Category extends Savable {
  Category({
    String? uid,
    required this.name,
    required this.codepoint,
    required this.iconColor,
    this.parent,
  }) {
    this.uid = uid ?? Uuid().v4();
  }

  @override
  late final String uid;

  String name;
  int codepoint;
  Color iconColor;
  String? parent;

  get iconData {
    return IconData(codepoint, fontFamily: 'MaterialIcons');
  }

  get icon {
    return Icon(iconData, color: iconColor);
  }
}

class ValidIcon {
  ValidIcon({
    required this.searchFields,
    required this.codepoint,
  });

  final List<String> searchFields;
  final int codepoint;
}

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

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  Future<Map<String, Category>> build() async {
    List<Category> items = await ref.read(categoriesPersistanceProvider.notifier).readAll();
    return Map.fromEntries(items.map((e) => MapEntry(e.uid, e)));
  }

  add(Category newCategory, Category parentCategory) async {
    newCategory.parent = parentCategory.uid;
    await ref.read(categoriesPersistanceProvider.notifier).create(newCategory);

    final previousState = await future;
    state = AsyncData(Map.from({...previousState, newCategory.uid: newCategory}));
  }
}
