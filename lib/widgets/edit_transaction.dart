import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TransactionType {
  expense(mustBeFromMine: true, mustBeToMine: false),
  income(mustBeFromMine: false, mustBeToMine: true),
  transfer(mustBeFromMine: true, mustBeToMine: true);

  const TransactionType({
    required this.mustBeFromMine,
    required this.mustBeToMine
  });

  final bool mustBeFromMine;
  final bool mustBeToMine;
}

class EditTransaction extends HookConsumerWidget {
  EditTransaction({
    super.key,
    required this.transactionType,
    required this.commit
  });
  
  final TransactionType transactionType;
  final void Function(Transaction) commit;

  final _formKey = GlobalKey<FormState>();
  
  final _fromAccountController = TextEditingController(text: '');
  final _toAccountController = TextEditingController(text: '');
  final _dateController = TextEditingController(text: DateTime.now().toDate());


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final myAccountNames = ref.watch(myAccountNamesProvider);
    final otherAccountNames = ref.watch(otherAccountNamesProvider);

    final name = useState('');
    final amount = useState<double>(0);
    final date = useState(DateTime.now());

    void submit() {
      if (_formKey.currentState!.validate()) {

        _formKey.currentState!.save();

        Account? from;
        Account? to;

        if (transactionType.mustBeFromMine) {
          from = ref.read(accountsProvider).firstWhere((element) => element.name == _fromAccountController.text);
          to = ref.read(accountsProvider).firstWhere((element) => element.name == _toAccountController.text,
              orElse: () => Account(name: _toAccountController.text, currency: from!.currency));
          ref.read(accountsProvider.notifier).add(to);
        } else {
          to = ref.read(accountsProvider).firstWhere((element) => element.name == _toAccountController.text);
          from = ref.read(accountsProvider).firstWhere((element) => element.name == _fromAccountController.text,
              orElse: () => Account(name: _fromAccountController.text, currency: from!.currency));
          ref.read(accountsProvider.notifier).add(from);
        }

        var newTransaction = Transaction(
          note: name.value,
          amount: (amount.value * pow(10, from.currency.decimals)).floor(),
          from: from,
          to: to,
          date: date.value,
          category: any,
        );

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
            TextFormField(
              initialValue: '',
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
              onSaved: (value) {
                amount.value = double.parse(value!);
              },
            ),
            // From Field
            FormField<String>(
              builder: (formFieldState) => LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return DropdownMenu<String>(
                    width: constraints.maxWidth,
                    requestFocusOnTap: true,
                    controller: _fromAccountController,
                    enableFilter: true,
                    label: const Text('From'),
                    dropdownMenuEntries: myAccountNames.map((e) => DropdownMenuEntry<String>(value: e, label: e)).toList(),
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
                if (transactionType.mustBeFromMine && !myAccountNames.contains(_fromAccountController.text)) {
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
                    width: constraints.maxWidth,
                    requestFocusOnTap: true,
                    controller: _toAccountController,
                    enableFilter: true,
                    label: const Text('To'),
                    dropdownMenuEntries: otherAccountNames.map((e) => DropdownMenuEntry<String>(value: e, label: e)).toList(),
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
                if (transactionType.mustBeToMine && !myAccountNames.contains(_toAccountController.text)) {
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
              onTap: (){
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
              decoration: const InputDecoration(
                label: Text('Note'),
              ),
              onSaved: (value) {
                name.value = value!;
              },
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
