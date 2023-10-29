import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/transaction_filter.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionFilterEditor extends HookConsumerWidget {
  TransactionFilterEditor({super.key});

  final _formKey = GlobalKey<FormState>();

  final filterController = TextEditingController();
  final fromAccountController = TextEditingController();
  final toAccountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionFilter = ref.watch(transactionFilterProvider);
    final categories = ref.watch(categoriesProvider);
    final accounts = ref.watch(accountsProvider);

    if (!categories.hasValue || !accounts.hasValue) {
      return Loading();
    }

    useEffect(() {
      filterController.text = transactionFilter.filter;
      fromAccountController.text = accounts.value![transactionFilter.source]?.name ?? "";
      toAccountController.text = accounts.value![transactionFilter.destination]?.name ?? "";
    });

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox.square(dimension: 10),
              Expanded(
                child: TextFormField(
                  controller: filterController,
                  decoration: InputDecoration(label: Text("Filter")),
                ),
              ),
              GFIconButton(
                icon: Icon(Icons.close, size: 24),
                onPressed: () {
                  filterController.text = "";
                },
                color: Colors.transparent,
              ),
            ],
          ),
          // From Field
          Row(
            children: [
              SizedBox.square(dimension: 10),
              Expanded(
                child: FormField<String>(
                  builder: (formFieldState) => LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return DropdownMenu<Account>(
                        width: constraints.maxWidth,
                        textStyle: const TextStyle(),
                        requestFocusOnTap: true,
                        controller: fromAccountController,
                        enableFilter: true,
                        label: const Text('From'),
                        dropdownMenuEntries: accounts.value!.values
                            .map((e) => DropdownMenuEntry<Account>(value: e, label: e.name))
                            .toList(),
                        inputDecorationTheme: const InputDecorationTheme(),
                        onSelected: (Account? selected) {
                          fromAccountController.text = selected?.name ?? "";
                        },
                        errorText: formFieldState.errorText,
                      );
                    },
                  ),
                  validator: (value) {
                    if (fromAccountController.text.isEmpty) {
                      return null;
                    }
                    var fromAccount = accounts.value!.values
                        .where(
                            (element) => element.name.toLowerCase() == fromAccountController.text.trim().toLowerCase())
                        .firstOrNull;
                    if (fromAccount == null) {
                      return 'Not a valid account';
                    }
                    return null;
                  },
                ),
              ),
              GFIconButton(
                icon: Icon(Icons.close, size: 24),
                onPressed: () {
                  fromAccountController.text = "";
                },
                color: Colors.transparent,
              ),
            ],
          ),
          // To Field
          Row(
            children: [
              SizedBox.square(dimension: 10),
              Expanded(
                child: FormField<String>(
                  builder: (toFieldState) => LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return DropdownMenu<Account>(
                        width: constraints.maxWidth,
                        textStyle: const TextStyle(),
                        requestFocusOnTap: true,
                        controller: toAccountController,
                        enableFilter: true,
                        label: const Text('To'),
                        dropdownMenuEntries: accounts.value!.values
                            .map((e) => DropdownMenuEntry<Account>(value: e, label: e.name))
                            .toList(),
                        inputDecorationTheme: const InputDecorationTheme(),
                        onSelected: (Account? selected) {
                          toAccountController.text = selected?.name ?? "";
                        },
                        errorText: toFieldState.errorText,
                      );
                    },
                  ),
                  validator: (value) {
                    if (toAccountController.text.isEmpty) {
                      return null;
                    }
                    var toAccount = accounts.value!.values
                        .where((element) => element.name.toLowerCase() == toAccountController.text.trim().toLowerCase())
                        .firstOrNull;
                    if (toAccount == null) {
                      return 'Not a valid account';
                    }
                    return null;
                  },
                ),
              ),
              GFIconButton(
                icon: Icon(Icons.close, size: 24),
                onPressed: () {
                  toAccountController.text = "";
                },
                color: Colors.transparent,
              ),
            ],
          ),
          SizedBox.square(dimension: 12),
          GFButton(
            child: Text("Submit"),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                var fromAccount = accounts.value!.values
                    .where((element) => element.name.toLowerCase() == fromAccountController.text.trim().toLowerCase())
                    .firstOrNull;
                transactionFilter.source = fromAccount?.uid;
                var toAccount = accounts.value!.values
                    .where((element) => element.name.toLowerCase() == toAccountController.text.trim().toLowerCase())
                    .firstOrNull;
                transactionFilter.destination = toAccount?.uid;
                transactionFilter.filter = filterController.text;

                ref.read(transactionFilterProvider.notifier).ref.notifyListeners();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
