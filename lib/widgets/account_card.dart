import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountCard extends ConsumerWidget {
  const AccountCard({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final currencies = ref.watch(currenciesProvider);

    if (!transactions.hasValue || !currencies.hasValue) {
      return Loading();
    }

    final currencyAmounts = Map<String, int>();

    for (var transaction in transactions.value!) {
      int amount = 0;
      if (transaction.from?.uid == account.uid) {
        amount = -transaction.amount;
      }

      if (transaction.to.uid == account.uid) {
        amount = transaction.amount;
      }

      if (amount != 0) {
        currencyAmounts.update(transaction.currency.uid, (value) => value + amount, ifAbsent: () => amount);
      }
    }

    var accountContents = currencyAmounts.entries.map<Widget>((entry) {
      return Text(currencies.value![entry.key]!.formatFull(entry.value));
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: Text(account.name)),
            Column(
              children: accountContents,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        ),
      ),
    );
  }
}
