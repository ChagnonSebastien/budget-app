import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/persistence/persistence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'categories.g.dart';

String LABEL_CATEGORIES = "Categories";
String _LABEL_NAME = "name";
String _LABEL_ICON_CODEPOINT = "iconCodepoint";
String _LABEL_ICON_COLOR_A = "iconColorA";
String _LABEL_ICON_COLOR_R = "iconColorR";
String _LABEL_ICON_COLOR_G = "iconColorG";
String _LABEL_ICON_COLOR_B = "iconColorB";
String _LABEL_PARENT = "parent";

@Riverpod(keepAlive: true)
class CategoriesPersistence extends _$CategoriesPersistence with Crud<Category> {
  @override
  Future<Database> build() => ref.watch(localDBProvider.future);

  @override
  String getTableName() => LABEL_CATEGORIES;

  @override
  Map<String, dynamic> toJson(Category element) {
    return {
      LABEL_UID: element.uid,
      _LABEL_NAME: element.name,
      _LABEL_ICON_CODEPOINT: element.codepoint,
      _LABEL_ICON_COLOR_R: element.iconColor.red,
      _LABEL_ICON_COLOR_G: element.iconColor.green,
      _LABEL_ICON_COLOR_B: element.iconColor.blue,
      _LABEL_ICON_COLOR_A: element.iconColor.alpha,
      _LABEL_PARENT: element.parent,
    };
  }

  @override
  Future<Category> fromJson(Map<String, dynamic> json) async {
    return Category(
      uid: json[LABEL_UID],
      name: json[_LABEL_NAME],
      codepoint: json[_LABEL_ICON_CODEPOINT],
      iconColor: Color.fromARGB(
        json[_LABEL_ICON_COLOR_A],
        json[_LABEL_ICON_COLOR_R],
        json[_LABEL_ICON_COLOR_G],
        json[_LABEL_ICON_COLOR_B],
      ),
      parent: json[_LABEL_PARENT],
    );
  }

  @override
  Future<void> init() async {
    final db = await future;
    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${LABEL_CATEGORIES} (
          ${LABEL_UID} VARCHAR(36) NOT NULL ,
          ${_LABEL_NAME} VARCHAR(255) NOT NULL ,
          ${_LABEL_ICON_CODEPOINT} INT NOT NULL,
          ${_LABEL_ICON_COLOR_A} INT NOT NULL,
          ${_LABEL_ICON_COLOR_R} INT NOT NULL,
          ${_LABEL_ICON_COLOR_G} INT NOT NULL,
          ${_LABEL_ICON_COLOR_B} INT NOT NULL,
          ${_LABEL_PARENT} VARCHAR(36),
          PRIMARY KEY (${LABEL_UID}),
          FOREIGN KEY (${_LABEL_PARENT}) REFERENCES ${LABEL_CATEGORIES}(${LABEL_UID})
        );
      ''');
  }

  @override
  Future<void> populateData() async {
    await Future.wait(Defaults.categories.asMap().values.map((e) => create(e)));
  }
}
