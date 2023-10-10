import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';


class CategoryTree extends StatelessWidget  {
  const CategoryTree({
    super.key,
    required this.onCategoryTap,
  });

  final Function(Category category) onCategoryTap;

  @override
  Widget build(BuildContext context) {

    List<Widget> view = [];

    void exploreCategory(Category category, int level) {
      view.add(ListTile(
        contentPadding: EdgeInsets.only( left: level * 20, right: 20 ),
        leading: Icon(category.iconData, color: category.iconColor),
        title: Text(category.name),
        onTap: () {
          onCategoryTap(category);
        },
      ));

      for (var element in category.subCategories) {
        exploreCategory(element, level + 1);
      }
    }

    exploreCategory(any, 1);

    return ListView(
      shrinkWrap: true,
      children: view,
    );
  }
}
