import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/widgets/category_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditCategory extends ConsumerWidget {
  EditCategory({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CategoryForm(
      initialCategory: category,
      commit: (editedCategory) {
        ref.read(categoriesProvider.notifier).editCategory(editedCategory);
        Navigator.pop(context);
      },
    );
  }
}
