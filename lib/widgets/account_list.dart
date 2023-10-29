import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/pages/account_edit.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/account_card.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountsList extends ConsumerWidget {
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    if (!accounts.hasValue) {
      return Loading();
    }

    return ReorderableListView(
      padding: const EdgeInsets.all(10),
      proxyDecorator: dragDecorator,
      onReorder: ref.read(accountsProvider.notifier).reorder,
      children: accounts.value!.values.where((element) => element.personal).map((account) {
        return GestureDetector(
          key: Key(account.uid),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditAccount(
                account: account,
              );
            }));
          },
          child: AccountCard(key: Key(account.name), account: account),
        );
      }).toList(),
    );
  }
}
