import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/account_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class MyAccounts extends ConsumerWidget {
  const MyAccounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final accounts = ref.watch(accountsProvider);
    final accountsNotifier = ref.watch(accountsProvider.notifier);

    return ReorderableListView(
      padding: const EdgeInsets.all(10),
      proxyDecorator: dragDecorator,
      onReorder: accountsNotifier.reorder,
      children: accounts.where((element) => element.personal).map((e) {
        return AccountCard(key: Key(e.name), account: e);
      }).toList(),

    );
  }
}