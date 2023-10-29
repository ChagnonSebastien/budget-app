import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/widgets/category_form.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditCategory extends ConsumerWidget {
  EditCategory({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('Edit Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CategoryForm(
              submitText: "Save",
              initialCategory: category,
              commit: (editedCategory) {
                ref.read(categoriesProvider.notifier).editCategory(editedCategory);
                Navigator.pop(context);
              },
            ),
            OutlinedButton(
              onPressed: () {
                ref.read(categoriesProvider.notifier).delete(category);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
