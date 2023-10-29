import 'package:flutter/material.dart';
import 'package:flutter_hello_world/pages/category_edit.dart';
import 'package:flutter_hello_world/pages/category_new.dart';
import 'package:flutter_hello_world/widgets/category_tree.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyCategories extends ConsumerWidget {
  const MyCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CategoryTree(onCategoryTap: (tappedCategory) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditCategory(category: tappedCategory);
        }));
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NewCategory();
          }));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
