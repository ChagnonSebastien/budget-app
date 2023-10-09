import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
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
