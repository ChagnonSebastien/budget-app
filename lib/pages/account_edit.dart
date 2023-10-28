import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/widgets/account_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditAccount extends ConsumerWidget {
  const EditAccount({super.key, required this.account});

  final Account account;

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
          initialAccount: account,
          submitText: "Save",
          commit: (updatedAccount) {
            ref.read(accountsProvider.notifier).updateAccount(updatedAccount);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
