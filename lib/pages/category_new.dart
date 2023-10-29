import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/widgets/category_form.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewCategory extends ConsumerWidget {
  NewCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('New Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: CategoryForm(
          commit: (newCategory) {
            ref.read(categoriesProvider.notifier).add(newCategory);
            Navigator.pop(context);
          },
          submitText: "Create",
        ),
      ),
    );
  }
}
