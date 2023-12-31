import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/transaction_form.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
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
      appBar: GFAppBar(
        title: const Text('Edit Transaction'),
      ),
      body: SingleChildScrollView(
        child: TransactionForm(
          transactionType: transaction.transactionType,
          initialTransaction: transaction,
          commit: (updatedTransaction) {
            if (updatedTransaction.from != null) {
              ref.read(accountsProvider.notifier).add(updatedTransaction.from!);
            }
            ref.read(accountsProvider.notifier).add(updatedTransaction.to);
            ref.read(transactionsProvider.notifier).editTransaction(updatedTransaction);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
