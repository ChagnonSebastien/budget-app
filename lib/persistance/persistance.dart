
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final authRepositoryProvider = FutureProvider<Database>((ref) async {
  WidgetsFlutterBinding.ensureInitialized();

  return openDatabase(

    join(await getDatabasesPath(), 'budget_database.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE currency(
          id CHAR(36) PRIMARY KEY,
          name TEXT,
          decimal SHORT
        )
        ''',
      
      );
    },
  );
});

