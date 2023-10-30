import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/transaction_filter.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/category_tree.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const dateFilterOptions = ["This Month", "This Year", "Last Month", "Last Year", "Custom Range"];

class TransactionFilterEditor extends HookConsumerWidget {
  TransactionFilterEditor({super.key});

  final _formKey = GlobalKey<FormState>();

  final filterController = TextEditingController();
  final fromAccountController = TextEditingController();
  final toAccountController = TextEditingController();
  final categoryController = TextEditingController();

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionFilter = ref.watch(transactionFilterProvider);
    final categories = ref.watch(categoriesProvider);
    final accounts = ref.watch(accountsProvider);

    if (!categories.hasValue || !accounts.hasValue) {
      return Loading();
    }

    final category = useState(transactionFilter.category);
    final dateFilter = useState("Custom Range");

    useEffect(() {
      categoryController.text = categories.value![category.value]?.name ?? "";
    }, [category.value]);

    useEffect(() {
      filterController.text = transactionFilter.filter;
      fromAccountController.text = accounts.value![transactionFilter.source]?.name ?? "";
      toAccountController.text = accounts.value![transactionFilter.destination]?.name ?? "";
      fromDateController.text = transactionFilter.from.toDate();
      toDateController.text = transactionFilter.to.toDate();
    });

    showCategorySelection() {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Parent Category', textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox.fromSize(size: const Size.square(15)),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 0,
                  ),
                  Expanded(
                    child: CategoryTree(
                      onCategoryTap: (tappedCategory) {
                        category.value = tappedCategory.uid;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    var customDates = [
      Row(children: [
        SizedBox.square(dimension: 10),
        // Date Field
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              label: Text('Between'),
            ),
            readOnly: true,
            controller: fromDateController,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: transactionFilter.from,
                firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                lastDate: DateTime.now(),
              ).then((value) {
                if (value != null) {}
              });
            },
          ),
        ),
        SizedBox.square(dimension: 10),
      ]),
      Row(children: [
        SizedBox.square(dimension: 10),
        // Date Field
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              label: Text('And'),
            ),
            readOnly: true,
            controller: toDateController,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: transactionFilter.to,
                firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                lastDate: DateTime.now(),
              ).then((value) {
                if (value != null) {}
              });
            },
          ),
        ),
        SizedBox.square(dimension: 10),
      ]),
    ];

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category Field
          Row(
            children: [
              SizedBox.square(dimension: 10),
              Expanded(
                child: TextFormField(
                  controller: categoryController,
                  onTap: showCategorySelection,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: const Text('Category'),
                    icon: categories.value![category.value]!.icon,
                  ),
                ),
              ),
              GFIconButton(
                icon: Icon(Icons.close, size: 24),
                onPressed: () {
                  category.value = rootCategoryUid;
                },
                color: Colors.transparent,
              ),
            ],
          ),
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

          Row(children: [
            SizedBox.square(dimension: 10),
            Expanded(
              child: FormField<String>(
                builder: (toFieldState) => LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return DropdownMenu<String>(
                      width: constraints.maxWidth,
                      textStyle: const TextStyle(),
                      enableSearch: false,
                      label: const Text('Date'),
                      dropdownMenuEntries:
                          dateFilterOptions.map((e) => DropdownMenuEntry<String>(value: e, label: e)).toList(),
                      inputDecorationTheme: const InputDecorationTheme(),
                      onSelected: (String? selected) {},
                    );
                  },
                ),
              ),
            ),
            SizedBox.square(dimension: 10),
          ]),
          ...customDates,
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
                transactionFilter.category = category.value;

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
