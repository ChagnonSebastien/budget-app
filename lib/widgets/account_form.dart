import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountForm extends HookConsumerWidget {
  AccountForm({super.key, required this.commit, this.initialAccount, required this.submitText});

  final Function(Account, Map<String, int>) commit;
  final Account? initialAccount;
  final String submitText;

  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(text: initialAccount?.name ?? "");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);
    final currencies = ref.watch(currenciesProvider);
    final transactions = ref.watch(transactionsProvider);

    if (!accounts.hasValue || !currencies.hasValue || !transactions.hasValue) {
      return Loading();
    }

    final existingInitialTransactions = transactions.value!.where((transaction) =>
        transaction.transactionType == TransactionType.initial && transaction.to.uid == initialAccount?.uid);

    final initialAmounts = useState(Map.fromEntries(currencies.value!.values.map((currency) {
      return MapEntry(
          currency,
          existingInitialTransactions
              .where((element) => element.currency.uid == currency.uid)
              .map((e) => TextEditingController(text: e.amountNumber))
              .firstOrNull);
    })));

    void submit() {
      if (_formKey.currentState!.validate()) {
        var newAccount = Account(uid: initialAccount?.uid, name: _nameController.text, personal: true);
        commit(
            newAccount,
            Map.fromEntries(initialAmounts.value.entries
                .where((element) => element.value != null)
                .map((entry) => MapEntry(entry.key.uid, entry.key.parseNumber(entry.value!.text)))));
      }
    }

    newCategory() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Currencies"),
                  ListView(
                    shrinkWrap: true,
                    children: initialAmounts.value.entries.where((element) {
                      return element.value == null;
                    }).map((e) {
                      return ListTile(
                        title: Text(e.key.name),
                        onTap: () {
                          initialAmounts.value = initialAmounts.value.map((key, value) {
                            return MapEntry(key, key.uid == e.key.uid ? TextEditingController() : value);
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
            autofocus: true,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Select new category name';
              }
              if (initialAccount?.name != _nameController.text &&
                  ref
                      .read(categoriesProvider)
                      .value!
                      .values
                      .map<String>((value) => value.name)
                      .contains(_nameController.text)) {
                return 'This name already exists for another category';
              }
              return null;
            },
          ),
          SizedBox.fromSize(size: const Size.square(10)),
          Row(
            children: [
              Expanded(child: Text("Initial Amounts", style: TextStyle(color: Theme.of(context).primaryColor))),
              OutlinedButton(
                onPressed: initialAmounts.value.values.contains(null) ? newCategory : null,
                child: Text("New"),
              ),
            ],
          ),
          Flexible(
            child: Column(
              children: initialAmounts.value.entries.where((element) {
                return element.value != null;
              }).map((e) {
                return Row(children: [
                  Flexible(
                    child: TextFormField(
                      controller: e.value,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text(e.key.name),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        double? amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Must be a number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox.fromSize(size: const Size.square(20)),
                  IconButton(
                    onPressed: () {
                      initialAmounts.value = initialAmounts.value.map((key, value) {
                        return MapEntry(key, key.uid == e.key.uid ? null : value);
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
                ]);
              }).toList(),
            ),
          ),
          SizedBox.fromSize(size: const Size.square(20)),
          FilledButton(
            onPressed: submit,
            child: Text(submitText),
          ),
        ],
      ),
    );
  }
}
