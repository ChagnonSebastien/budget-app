import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/persistance/persistance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';


final String rootCategoryUid = "830472ff-c3fa-4a38-9e2d-d3f4b4e1268a";

class Category with UniqueId {
  Category({
    String? uid,
    required this.name,
    required this.codepoint,
    required this.iconColor,
  }) {
    this.uid = uid ?? Uuid().v4();
  }

  @override
  late final String uid;

  String name;
  int codepoint;
  Color iconColor;
  List<Category> subCategories = [];
  Category? parent;

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
  List<ValidIcon> validIcons = icons.map((icon) => ValidIcon(
        searchFields: List<String>.from(icon['tags']),
        codepoint: int.parse(icon['codepoint'].substring(2), radix: 16),
      )).toList();
  ref.keepAlive();
  return validIcons;
}


String _LABEL_CATEGORIES = "Categories";
String _LABEL_UID = "uid";
String _LABEL_NAME = "name";
String _LABEL_ICON_CODEPOINT = "iconCodepoint";
String _LABEL_ICON_COLOR_A = "iconColorA";
String _LABEL_ICON_COLOR_R = "iconColorR";
String _LABEL_ICON_COLOR_G = "iconColorG";
String _LABEL_ICON_COLOR_B = "iconColorB";
String _LABEL_PARENT = "parent";

extension JSON on Category {
  toJson() {
    final values = {
      _LABEL_UID: uid,
      _LABEL_NAME: name,
      _LABEL_ICON_CODEPOINT: codepoint,
      _LABEL_ICON_COLOR_R: iconColor.red,
      _LABEL_ICON_COLOR_G: iconColor.green,
      _LABEL_ICON_COLOR_B: iconColor.blue,
      _LABEL_ICON_COLOR_A: iconColor.alpha,
      _LABEL_PARENT: parent?.uid,
    };
    return values;
  }
}

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  @override
  Future<Map<String, Category>> build() async {
    final db = await ref.watch(databaseProvider.future);
    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${_LABEL_CATEGORIES} (
          ${_LABEL_UID} VARCHAR(36) NOT NULL ,
          ${_LABEL_NAME} VARCHAR(255) NOT NULL ,
          ${_LABEL_ICON_CODEPOINT} INT NOT NULL,
          ${_LABEL_ICON_COLOR_A} INT NOT NULL,
          ${_LABEL_ICON_COLOR_R} INT NOT NULL,
          ${_LABEL_ICON_COLOR_G} INT NOT NULL,
          ${_LABEL_ICON_COLOR_B} INT NOT NULL,
          ${_LABEL_PARENT} VARCHAR(36),
          PRIMARY KEY (${_LABEL_UID}),
          FOREIGN KEY (${_LABEL_PARENT}) REFERENCES ${_LABEL_CATEGORIES}(${_LABEL_UID})
        );
      ''');

    await Future.wait(Defaults.categories.asMap().values.map(_add));

    Map<String, Category> items = {};
    Map<String, String> parents = {};
    List<Map<String, dynamic>> response = await db.query(_LABEL_CATEGORIES);

    response.forEach((event) {
      items.putIfAbsent(
          event[_LABEL_UID],
          () => Category(
              uid: event[_LABEL_UID],
              name: event[_LABEL_NAME],
              codepoint: event[_LABEL_ICON_CODEPOINT],
              iconColor: Color.fromARGB(
                event[_LABEL_ICON_COLOR_A],
                event[_LABEL_ICON_COLOR_R],
                event[_LABEL_ICON_COLOR_G],
                event[_LABEL_ICON_COLOR_B],
              )));
      if (event.containsKey(_LABEL_PARENT) && event[_LABEL_PARENT] != null) {
        parents.putIfAbsent(event[_LABEL_UID], () => event[_LABEL_PARENT]);
      }
    });

    parents.forEach((key, value) {
      items[key]!.parent = items[key]!;
      items[value]!.subCategories.add(items[key]!);
    });

    return items;
  }

  Future<void> _add(Category newCategory) async {
    final db = await ref.watch(databaseProvider.future);
    await db.insert(_LABEL_CATEGORIES, newCategory.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  add(Category newCategory, Category parentCategory) async {
    newCategory.parent = parentCategory;
    parentCategory.subCategories.add(newCategory);
    await _add(newCategory);

    final previousState = await future;
    state = AsyncData(Map.from({...previousState, newCategory.uid: newCategory}));
  }
}
