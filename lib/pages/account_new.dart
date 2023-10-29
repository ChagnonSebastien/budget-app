import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/account_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewAccount extends ConsumerWidget {
  const NewAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: AccountForm(
          submitText: "Create",
          commit: (newAccount, initialAmounts) async {
            await ref.read(accountsProvider.notifier).create(newAccount);
            ref.read(transactionsProvider.notifier).overwriteInitialAmounts(newAccount, initialAmounts);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
