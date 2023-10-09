import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hello_world/account.dart';
import 'package:flutter_hello_world/transaction.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewTransaction extends StatefulHookConsumerWidget {
  const NewTransaction({super.key, required this.commit});
  
  final void Function(Transaction) commit;

  @override
  ConsumerState<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends ConsumerState<NewTransaction> {
  
  final _formKey = GlobalKey<FormState>();

  String? _name;
  double? _amount;
  String? _fromName;
  String? _toName;
  DateTime _date = DateTime.now();

  
  final TextEditingController _fromAccountController = TextEditingController();
  final TextEditingController _toAccountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(text: format(DateTime.now()));


  @override
  Widget build(BuildContext context) {
    final accountManager = ref.watch(accountsProvider.notifier);
    final myAccountNames = ref.watch(myAccountNamesProvider);
    final otherAccountNames = ref.watch(otherAccountNamesProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'New Transaction',
              style: TextStyle(
                fontSize: 20
              ),
            ),
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            TextFormField(
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
                setState(() {
                  _amount = double.parse(value!);
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Date'),
              ),
              controller: _dateController,
              onTap: (){
                // Below line stops keyboard from appearing
                FocusScope.of(context).unfocus();

                // Show Date Picker Here
                showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                  lastDate: DateTime.now(),
                ).then((value) {
                  if (value != null) {
                    _dateController.text = format(value);
                    setState(() {
                      _date = value.add(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second));
                    });
                  }
                });
              },
            ),
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
              validator: (value) {
                if (_fromAccountController.text.isEmpty) {
                  return 'Please enter the source account';
                }
                if (!myAccountNames.contains(_fromAccountController.text)) {
                  return 'Not valid, must one of your accout.';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _fromName = _fromAccountController.text;
                });
              },
            ),
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
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _toName = _toAccountController.text.toTitleCase();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Account? from = accountManager.get(_fromName!);
                    from ??= Account(name: _fromName!, currency: cad);

                    Account? to = accountManager.get(_toName!);
                    if (to == null) {
                      to = Account(name: _toName!, currency: from.currency);
                      accountManager.add(to);
                    }

                    widget.commit(Transaction(
                      name: _name!,
                      amount: (_amount! * pow(10, from.currency.decimals)).floor(),
                      from: from,
                      to: to,
                      date: _date,
                    ));
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        )
      ),
    );
  }
}
