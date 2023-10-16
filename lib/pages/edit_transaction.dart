import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/transaction_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class EditTransaction extends ConsumerWidget {
  const EditTransaction({
    super.key,
    required this.transaction,
  });
  
  final Transaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Edit Transaction'),
      ),
      body: SingleChildScrollView(
        child:  TransactionForm(
          transactionType: transaction.transactionType,
          initialTransaction: transaction,
          commit: (t) {
            ref.read(accountsProvider.notifier).add(t.from);
            ref.read(accountsProvider.notifier).add(t.to);
            ref.read(transactionsProvider.notifier).editTransaction(transaction.id, t);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
