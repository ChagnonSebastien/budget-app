import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hello_world/pages/accounts.dart';
import 'package:flutter_hello_world/pages/categories.dart';
import 'package:flutter_hello_world/pages/transactions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


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
    widget: () => MyAccounts(),
  ),
  Page(
    name: 'Categories',
    icon: const Icon(Icons.category_outlined),
    selectedIcon: const Icon(Icons.category),
    widget: () => MyCategories(),
  ),
];

class Home extends HookWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    final selectedPageIndex = useState(2);

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[selectedPageIndex.value].name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: (value) {
          if (value < pages.length) {
            selectedPageIndex.value = value;
          } else if (value == 2) {
            // TODO: Settings page
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
          )
        ],
      ),
      body: pages[selectedPageIndex.value].widget(),
    );
  }
}

