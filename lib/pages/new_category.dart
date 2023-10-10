import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:flutter_hello_world/widgets/category_tree.dart';
import 'package:flutter_hello_world/widgets/edit_transaction.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class NewCategory extends HookConsumerWidget {
  NewCategory({
    super.key,
  });

  final _textCategory = TextEditingController(text: any.name);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final category = useState(any);

    final showCategorySelection = useCallback(() {
      Future.delayed(Duration.zero, () => showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Parent Category', textScaleFactor: 1.2),
                  CategoryTree(
                    onCategoryTap: (tappedCategory) {
                      category.value = tappedCategory;
                      _textCategory.text = tappedCategory.name;
                      Navigator.pop(context);
                    }
                  ),
                ],
              ),
            ),
          );
        },
      ));
    });

    void submit() {

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('New Category'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _textCategory,
                onTap: showCategorySelection,
                readOnly: true,
                decoration: InputDecoration(
                  label: const Text('Parent category'),
                  icon: Icon(category.value.iconData, color: category.value.iconColor),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),

              ),
              SizedBox.fromSize(size: const Size.square(20)),
              FilledButton(
                onPressed: submit,
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
