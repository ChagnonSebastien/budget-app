import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/pages/accounts.dart';
import 'package:flutter_hello_world/pages/categories.dart';
import 'package:flutter_hello_world/pages/transactions.dart';
import 'package:flutter_hello_world/persistance/accounts.dart';
import 'package:flutter_hello_world/persistance/categories.dart';
import 'package:flutter_hello_world/persistance/currencies.dart';
import 'package:flutter_hello_world/persistance/transactions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Page {
  const Page({
    required this.name,
    required this.icon,
    required this.selectedIcon,
    required this.widget,
  });

  final String name;
  final Icon icon;
  final Icon selectedIcon;
  final Widget Function() widget;
}

var pages = [
  Page(
    name: 'Transactions',
    icon: const Icon(Icons.receipt_long_outlined),
    selectedIcon: const Icon(Icons.receipt_long),
    widget: () => MyTransactions(),
  ),
  Page(
    name: 'Accounts',
    icon: const Icon(Icons.account_balance_outlined),
    selectedIcon: const Icon(Icons.account_balance),
    widget: () => const MyAccounts(),
  ),
  Page(
    name: 'Categories',
    icon: const Icon(Icons.category_outlined),
    selectedIcon: const Icon(Icons.category),
    widget: () => const MyCategories(),
  ),
];

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageIndex = useState(0);

    factoryResetDB() async  {
      final populateTransactions = await ref.read(transactionsProvider.notifier).factoryReset();
      final populateCategories = await ref.read(categoriesProvider.notifier).factoryReset();
      final populateCurrencies = await ref.read(currenciesProvider.notifier).factoryReset();
      final populateAccounts = await ref.read(accountsProvider.notifier).factoryReset();
      await populateAccounts();
      await populateCurrencies();
      await populateCategories();
      await populateTransactions();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[selectedPageIndex.value].name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: (value) {
          if (value < pages.length) {
            selectedPageIndex.value = value;
          } else if (value == 3) {
            // TODO: Settings page
          } else if (value == 4) {
            print("HAIMDALL factory reset");
            factoryResetDB();
          }
          Navigator.pop(context);
        },
        selectedIndex: selectedPageIndex.value,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              'Pages',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...pages.map((page) => NavigationDrawerDestination(
                label: Text(page.name),
                icon: page.icon,
                selectedIcon: page.selectedIcon,
              )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Divider(),
          ),
          const NavigationDrawerDestination(
            label: Text("Settings"),
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
          ),
          const NavigationDrawerDestination(
            label: Text("Reset DB"),
            icon: Icon(Icons.restart_alt_outlined),
            selectedIcon: Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: pages[selectedPageIndex.value].widget(),
    );
  }
}
