import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryTree extends HookConsumerWidget {
  const CategoryTree({
    super.key,
    required this.onCategoryTap,
    this.disabled,
  });

  final Function(Category category) onCategoryTap;
  final String? disabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var categories = ref.watch(categoriesProvider);

    if (!categories.hasValue || !categories.value!.containsKey(rootCategoryUid)) {
      return Loading();
    }

    List<Widget> view = [];

    void exploreCategory(Category category, int level) {
      if (category.uid == disabled) {
        return;
      }

      view.add(ListTile(
        contentPadding: EdgeInsets.only(left: level * 20, right: 20),
        leading: category.icon,
        title: Text(category.name),
        onTap: () {
          onCategoryTap(category);
        },
      ));

      var children =
          categories.value!.values.where((element) => element.parent == category.uid && element.uid != category.uid);
      for (var element in children) {
        exploreCategory(element, level + 1);
      }
    }

    exploreCategory(categories.value![rootCategoryUid]!, 1);

    return ListView(
      shrinkWrap: true,
      children: view,
    );
  }
}
