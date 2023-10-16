
import 'dart:async';

import 'package:flutter/widgets.dart';
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

mixin UniqueId {
  String get uid;
}

abstract class Savable {
  String get id;
}

mixin DataModel<Model extends Savable> {
  FutureOr<void> initDataState(Database db);
  FutureOr<Model> get(Database db, String id);
  FutureOr<Stream<Model>> getAll(Database db);
  FutureOr<void> save(Database db, Model data);
}
