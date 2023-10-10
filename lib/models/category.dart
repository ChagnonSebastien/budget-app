import 'package:flutter/material.dart';


class Category {
  Category({
    required this.name,
    required this.iconData,
    required this.iconColor,
    List<Category>? subCategories,
  }) {
    this.subCategories = subCategories ?? [];
  }

  final String name;
  final IconData iconData;
  final Color iconColor;
  late List<Category> subCategories;
}


Category groceries = Category(
  name: 'Groceries',
  iconData: Icons.shopping_basket,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
);

Category fastFood = Category(
  name: 'Fast food',
  iconData: Icons.fastfood,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
);

Category goingOut = Category(
  name: 'Restaurant',
  iconData: Icons.restaurant,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
);

Category food = Category(
  name: 'Food',
  iconData: Icons.dinner_dining,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
  subCategories: [groceries, fastFood, goingOut],
);

Category any = Category(
  name: 'Any',
  iconData: Icons.category,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
  subCategories: [food],
);


