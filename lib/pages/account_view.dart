import 'package:flutter/material.dart';
import 'package:flutter_hello_world/pages/account_new.dart';
import 'package:flutter_hello_world/widgets/account_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyAccounts extends ConsumerWidget {
  const MyAccounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AccountsList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const NewAccount();
          }));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
