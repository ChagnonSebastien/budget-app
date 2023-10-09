import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hello_world/account.dart';
import 'package:flutter_hello_world/category.dart';
import 'package:flutter_hello_world/transaction.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class MyAccounts extends ConsumerWidget {
  const MyAccounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final accounts = ref.watch(accountsProvider);

    return ListView(
      children: accounts.where((element) => element.personal).map((e) => ListTile(title: Text(e.name),)).toList(),
    );
  }
}
