import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/category.dart';

class Defaults {
  static Categories? _categories;

  static Categories get categories {
    _categories ??= Categories();
    return _categories!;
  }
}

class Categories {
  Categories() {
    food.parent = any;
    groceries.parent = food;
    fastFood.parent = food;
    goingOut.parent = food;
    any.subCategories = [food];
    food.subCategories = [groceries, fastFood, goingOut];
  }


  final Category any = Category(
    uid: rootCategoryUid,
    name: 'Any',
    codepoint: Icons.category.codePoint,
    iconColor: const Color.fromARGB(255, 215, 109, 61),
  );

  final Category food = Category(
    name: 'Food',
    codepoint: Icons.dinner_dining.codePoint,
    iconColor: const Color.fromARGB(255, 215, 109, 61),
  );

  final Category groceries = Category(
    name: 'Groceries',
    codepoint: Icons.shopping_basket.codePoint,
    iconColor: const Color.fromARGB(255, 215, 109, 61),
  );

  final Category fastFood = Category(
    name: 'Fast food',
    codepoint: Icons.fastfood.codePoint,
    iconColor: const Color.fromARGB(255, 215, 109, 61),
  );

  final Category goingOut = Category(
    name: 'Restaurant',
    codepoint: Icons.restaurant.codePoint,
    iconColor: const Color.fromARGB(255, 215, 109, 61),
  );

  Map<String, Category> asMap() {
    return {
      any.uid: any,
      food.uid: food,
      groceries.uid: groceries,
      fastFood.uid: fastFood,
      goingOut.uid: goingOut,
    };
  }
}
