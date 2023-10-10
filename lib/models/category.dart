import 'package:flutter/material.dart';


class Category {
  const Category({
    required this.name,
    required this.iconData,
    required this.iconColor,
    this.parent,
  });

  final String name;
  final IconData iconData;
  final Color iconColor;
  final Category? parent;
}

Category food = const Category(
  name: 'Food',
  iconData: Icons.dinner_dining,
  iconColor: Color.fromARGB(255, 175, 74, 28),
);

Category groceries = Category(
  parent: food,
  name: 'Groceries',
  iconData: Icons.shopping_basket,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
);

Category fastFood = Category(
  parent: food,
  name: 'Fast food',
  iconData: Icons.fastfood,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
);

Category goingOut = Category(
  parent: food,
  name: 'Restaurant',
  iconData: Icons.restaurant,
  iconColor: const Color.fromARGB(255, 175, 74, 28),
);

