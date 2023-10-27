import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

part 'persistence.g.dart';

@Riverpod(keepAlive: true)
Future<Database> database(DatabaseRef _) async {
  WidgetsFlutterBinding.ensureInitialized();

  return openDatabase(
    join(await getDatabasesPath(), 'budget_database.db'),
    version: 1,
  );
}

String LABEL_UID = "uid";

mixin Crud<Model extends Savable> {
  bool initiated = false;

  Future<Database> get future;

  String getTableName();

  Map<String, dynamic> toJson(Model element);
  Future<Model> fromJson(Map<String, dynamic> json);

  Future<void> init();

  Future<void> populateData();

  Future<void> create(Model newElement, {ConflictAlgorithm? conflictAlgorithm}) async {
    final db = await future;
    if (!initiated) {
      initiated = true;
      await init();
    }
    await db.insert(getTableName(), toJson(newElement), conflictAlgorithm: conflictAlgorithm ?? ConflictAlgorithm.fail);
  }

  Future<Model> read(String uid) async {
    final db = await future;
    if (!initiated) {
      initiated = true;
      await init();
    }
    List<Map<String, Object?>> elements = await db.query(getTableName(), where: '$LABEL_UID = ?', whereArgs: [uid]);
    if (elements.length == 0) {
      throw 'Element not found!';
    }
    return fromJson(elements[0]);
  }

  Future<List<Model>> readAll() async {
    final db = await future;
    if (!initiated) {
      initiated = true;
      await init();
    }
    List<Map<String, dynamic>> response = await db.query(getTableName());
    return Future.wait(response.map((element) => fromJson(element)));
  }

  Future<void> updateElement(Model element) async {
    final db = await future;
    await db.update(getTableName(), toJson(element), where: '$LABEL_UID = ?', whereArgs: [element.uid]);
  }

  Future<void> delete(String uid) async {
    final db = await future;
    await db.delete(getTableName(), where: '$LABEL_UID = ?', whereArgs: [uid]);
  }

  Future<void> deleteAll() async {
    final db = await future;
    await db.delete(getTableName());
  }
}
