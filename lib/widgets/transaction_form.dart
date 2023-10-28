import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionForm extends HookConsumerWidget {
  TransactionForm({
    super.key,
    required this.transactionType,
    required this.commit,
    this.initialTransaction,
  });

  final TransactionType transactionType;
  final void Function(Transaction) commit;
  final Transaction? initialTransaction;

  final _formKey = GlobalKey<FormState>();

  late final _amountController = TextEditingController(text: initialTransaction?.amountNumber ?? '');
  late final _currencyController = TextEditingController(text: initialTransaction?.currency.name ?? '');
  late final _fromAccountController = TextEditingController(text: initialTransaction?.from?.name ?? '');
  late final _toAccountController = TextEditingController(text: initialTransaction?.to.name ?? '');
  late final _noteController = TextEditingController(text: initialTransaction?.note ?? '');
  late final _dateController =
      TextEditingController(text: initialTransaction?.date.toDate() ?? DateTime.now().toDate());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final currencies = ref.watch(currenciesProvider);

    final myAccountNames = ref.watch(myAccountNamesProvider);
    final otherAccountNames = ref.watch(otherAccountNamesProvider);

    if (!categories.hasValue || !currencies.hasValue || !myAccountNames.hasValue || !otherAccountNames.hasValue) {
      return Loading();
    }

    final date = useState(initialTransaction?.date ?? DateTime.now());

    void submit() async {
      if (_formKey.currentState!.validate()) {
        Account? from;
        Account? to;
        Currency currency = Defaults.currencies.cad;

        final accountsNotifier = ref.read(accountsProvider.notifier);
        if (transactionType.mustBeFromMine) {
          from = await accountsNotifier.withName(_fromAccountController.text);
          to = await accountsNotifier.withName(_toAccountController.text,
              orElse: Account(name: _toAccountController.text));
          ref.read(accountsProvider.notifier).add(to);
        } else {
          to = await accountsNotifier.withName(_toAccountController.text);
          from = await accountsNotifier.withName(_fromAccountController.text,
              orElse: Account(name: _fromAccountController.text));
          ref.read(accountsProvider.notifier).add(from);
        }

        var newTransaction = Transaction(
          uid: initialTransaction?.uid,
          amount: (double.parse(_amountController.text) * pow(10, currency.decimals)).floor(),
          from: from,
          to: to,
          date: date.value,
          category: categories.value![rootCategoryUid]!,
          currency: Defaults.currencies.cad,
        );
        String reducedNote = _noteController.text.trim();
        if (reducedNote != '') {
          newTransaction.note = reducedNote;
        }

        commit(newTransaction);
      }
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Amount Field
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _amountController,
                    autofocus: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Amount'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the transaction value';
                      }
                      double? amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Must be a number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 30),
                Flexible(
                  child: FormField<String>(
                    builder: (formFieldState) => LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return DropdownMenu<String>(
                          textStyle: const TextStyle(),
                          width: constraints.maxWidth,
                          requestFocusOnTap: true,
                          enableFilter: true,
                          controller: _currencyController,
                          label: const Text('Currency'),
                          dropdownMenuEntries: Defaults.currencies.asList().map((e) {
                            return DropdownMenuEntry(label: e.name, value: e.uid);
                          }).toList(),
                          inputDecorationTheme: const InputDecorationTheme(),
                          onSelected: (String? selected) {
                            _currencyController.text = currencies.value![selected!]!.name;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            // From Field
            FormField<String>(
              builder: (formFieldState) => LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return DropdownMenu<String>(
                    textStyle: const TextStyle(),
                    width: constraints.maxWidth,
                    requestFocusOnTap: true,
                    controller: _fromAccountController,
                    enableFilter: true,
                    label: const Text('From'),
                    dropdownMenuEntries:
                        myAccountNames.value!.map((e) => DropdownMenuEntry<String>(value: e, label: e)).toList(),
                    inputDecorationTheme: const InputDecorationTheme(),
                    onSelected: (String? selected) {
                      _fromAccountController.text = selected!;
                    },
                    errorText: formFieldState.errorText,
                  );
                },
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (_fromAccountController.text.isEmpty) {
                  return 'Please enter the source account';
                }
                if (transactionType.mustBeFromMine && !myAccountNames.value!.contains(_fromAccountController.text)) {
                  return 'Not valid, must one of your account.';
                }
                return null;
              },
            ),
            // To Field
            FormField<String>(
              builder: (formFieldState) => LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return DropdownMenu<String>(
                    textStyle: const TextStyle(),
                    width: constraints.maxWidth,
                    requestFocusOnTap: true,
                    controller: _toAccountController,
                    enableFilter: true,
                    label: const Text('To'),
                    dropdownMenuEntries:
                        otherAccountNames.value!.map((e) => DropdownMenuEntry<String>(value: e, label: e)).toList(),
                    inputDecorationTheme: const InputDecorationTheme(),
                    onSelected: (String? selected) {
                      _toAccountController.text = selected!;
                    },
                    errorText: formFieldState.errorText,
                  );
                },
              ),
              validator: (value) {
                if (_toAccountController.text.isEmpty) {
                  return 'Please enter the destination account';
                }
                if (transactionType.mustBeToMine && !myAccountNames.value!.contains(_toAccountController.text)) {
                  return 'Not valid, must one of your account.';
                }
                return null;
              },
            ),
            // Date Field
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Date'),
              ),
              controller: _dateController,
              readOnly: true,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: date.value,
                  firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                  lastDate: DateTime.now(),
                ).then((value) {
                  if (value != null) {
                    _dateController.text = value.toDate();
                    var now = DateTime.now();
                    date.value = value.add(Duration(hours: now.hour, minutes: now.minute, seconds: now.second));
                  }
                });
              },
            ),
            // Name Field
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                label: Text('Note'),
              ),
            ),
            SizedBox.fromSize(size: const Size.square(20)),
            FilledButton(
              onPressed: submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
