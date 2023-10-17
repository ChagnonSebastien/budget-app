
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

part 'persistance.g.dart';

@Riverpod(keepAlive: true)
Future<Database> database(DatabaseRef _) async {
  WidgetsFlutterBinding.ensureInitialized();

  await deleteDatabase(join(await getDatabasesPath(), 'budget_database.db'));

  return openDatabase(
    join(await getDatabasesPath(), 'budget_database.db'),
    version: 1,
    onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Currencies (
          name VARCHAR(255) NOT NULL,
          decimals TINYINT NOT NULL,
          symbol VARCHAR(63) NOT NULL,
          showSymbolBeforeAmount BOOLEAN NOT NULL,
          PRIMARY KEY (name)
        );
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Accounts (
          name VARCHAR(255) NOT NULL,
          personal BOOLEAN NOT NULL,
          PRIMARY KEY (name)
        );
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Transactions (
          uid VARCHAR(36) NOT NULL,
          amount INT NOT NULL,
          currency VARCHAR(36) NOT NULL,
          from_account VARCHAR(36) NOT NULL,
          to_account VARCHAR(36) NOT NULL,
          date INT NOT NULL,
          category VARCHAR(36) NOT NULL,
          note VARCHAR(255),
          PRIMARY KEY (uid),
          FOREIGN KEY (from_account) REFERENCES Accounts(name),
          FOREIGN KEY (to_account) REFERENCES Accounts(name),
          FOREIGN KEY (category) REFERENCES Categories(uid),
          FOREIGN KEY (currency) REFERENCES Currencies(name)
        );
      ''');
    },
  );
}

String LABEL_UID = "uid";

mixin Crud<Model extends Savable> {

  bool initiated = false;

  Future<Database> get future;

  String getTableName();

  Map<String, dynamic> toJson(Model element);
  Model fromJson(Map<String, dynamic> json);

  Future<void> init();

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
    return response.map((element) => fromJson(element)).toList();
  }
}