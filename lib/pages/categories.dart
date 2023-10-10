import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/pages/new_category.dart';
import 'package:flutter_hello_world/utils.dart';
import 'package:flutter_hello_world/widgets/account_card.dart';
import 'package:flutter_hello_world/widgets/category_tree.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class MyCategories extends ConsumerWidget {
  const MyCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CategoryTree(
        onCategoryTap: (tappedCategory) {
          // TODO Edit Category
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewCategory();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
