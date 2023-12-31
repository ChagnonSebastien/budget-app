import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/transaction_form.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewTransaction extends ConsumerWidget {
  const NewTransaction({
    super.key,
    required this.transactionType,
  });

  final TransactionType transactionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('New Transaction'),
      ),
      body: SingleChildScrollView(
        child: TransactionForm(
          transactionType: transactionType,
          commit: (transaction) {
            if (transaction.from != null) {
              ref.read(accountsProvider.notifier).add(transaction.from!);
            }
            ref.read(accountsProvider.notifier).add(transaction.to);
            ref.read(transactionsProvider.notifier).newTransaction(transaction);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
