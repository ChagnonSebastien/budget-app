import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/transaction_filter.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:flutter_hello_world/widgets/transaction_filter_editor.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionFilterDisplay extends HookConsumerWidget {
  TransactionFilterDisplay({super.key});

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

    final labelFormat = TextStyle(
      fontSize: 12,
      fontStyle: FontStyle.normal,
    );

    final emptyValueFormat = TextStyle(
      fontSize: 12,
      color: Theme.of(context).colorScheme.surfaceTint,
      fontStyle: FontStyle.italic,
    );

    final valueFormat = TextStyle(
      fontSize: 12,
      color: Theme.of(context).colorScheme.primary,
      fontStyle: FontStyle.italic,
    );

    displayFilters() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TransactionFilterEditor(),
            ),
          );
        },
      );
    }

    return GFCard(
      color: Theme.of(context).colorScheme.secondaryContainer,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(5),
      shape: Border(),
      content: Row(children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Filter: ", style: labelFormat),
                          Text("From: ", style: labelFormat),
                          Text("To: ", style: labelFormat),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          transactionFilter.filter == ""
                              ? Text("No filter", style: emptyValueFormat)
                              : Text(transactionFilter.filter, style: valueFormat),
                          transactionFilter.source == null
                              ? Text("Any account", style: emptyValueFormat)
                              : Text(accounts.value![transactionFilter.source]!.name, style: valueFormat),
                          transactionFilter.destination == null
                              ? Text("Any account", style: emptyValueFormat)
                              : Text(accounts.value![transactionFilter.destination]!.name, style: valueFormat),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Category: ", style: labelFormat),
                          Text("Between: ", style: labelFormat),
                          Text("End: ", style: labelFormat),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Icon(categories.value![transactionFilter.category]!.iconData,
                                color: categories.value![transactionFilter.category]!.iconColor, size: 12),
                            SizedBox.square(dimension: 3),
                            Text(categories.value![transactionFilter.category]!.name, style: valueFormat),
                          ]),
                          Text(transactionFilter.from.toDate(), style: valueFormat),
                          Text(transactionFilter.to.toDate(), style: valueFormat),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        GFIconButton(icon: Icon(Icons.filter_list), onPressed: displayFilters, iconSize: 20, color: Colors.transparent),
      ]),
    );
  }
}
