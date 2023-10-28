import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/pages/account_list.dart';
import 'package:flutter_hello_world/pages/category_list.dart';
import 'package:flutter_hello_world/pages/transaction_view.dart';
import 'package:flutter_hello_world/persistence/persistence.dart';
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
    final selectedPageIndex = useState(2);

    Future<void> factoryResetDB() async {
      await ref.read(localDBProvider.notifier).factoryReset();
      await ref.read(accountsProvider.notifier).factoryReset();
      await ref.read(currenciesProvider.notifier).factoryReset();
      await ref.read(categoriesProvider.notifier).factoryReset();
      await ref.read(transactionsProvider.notifier).factoryReset();
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
            print("HEIMDALL factory reset");
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
      body: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: pages[selectedPageIndex.value].widget())),
    );
  }
}
