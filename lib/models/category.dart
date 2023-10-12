import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Category {
  Category({
    required this.name,
    required this.codepoint,
    required this.iconColor,
    List<Category>? subCategories,
  }) {
    this.subCategories = subCategories ?? [];
  }

  final String name;
  final int codepoint;
  final Color iconColor;
  late List<Category> subCategories;

  get iconData {
    return IconData(codepoint, fontFamily: 'MaterialIcons');
  }

  get icon {
    return Icon(iconData, color: iconColor);
  }
}

Category groceries = Category(
  name: 'Groceries',
  codepoint: Icons.shopping_basket.codePoint,
  iconColor: const Color.fromARGB(255, 215, 109, 61),
);

Category fastFood = Category(
  name: 'Fast food',
  codepoint: Icons.fastfood.codePoint,
  iconColor: const Color.fromARGB(255, 215, 109, 61),
);

Category goingOut = Category(
  name: 'Restaurant',
  codepoint: Icons.restaurant.codePoint,
  iconColor: const Color.fromARGB(255, 215, 109, 61),
);

Category food = Category(
  name: 'Food',
  codepoint: Icons.dinner_dining.codePoint,
  iconColor: const Color.fromARGB(255, 215, 109, 61),
  subCategories: [groceries, fastFood, goingOut],
);

Category any = Category(
  name: 'Any',
  codepoint: Icons.category.codePoint,
  iconColor: const Color.fromARGB(255, 215, 109, 61),
  subCategories: [food],
);

class CategoryManager extends StateNotifier<List<Category>> {
  CategoryManager(List<Category>? initialCategories): super(initialCategories ?? [any]);

  add(Category newCategory, Category parentCategory) {
    parentCategory.subCategories.add(newCategory);
    state = [...state, newCategory];
  }

}

final categoriesProvider = StateNotifierProvider<CategoryManager, List<Category>>((ref) {
  return CategoryManager([any, food, goingOut, fastFood, groceries]);
});

class ValidIcon {
  ValidIcon({
    required this.searchFields,
    required this.codepoint,
  });

  final List<String> searchFields;
  final int codepoint;
}

final materialIconData = FutureProvider<List<ValidIcon>>(((_) async {
  String data = await rootBundle.loadString('assets/iconMetadata.json');
  List<Map<String, dynamic>> icons = List<Map<String, dynamic>>.from(jsonDecode(data));
  Iterable<ValidIcon> validIcons = icons.map((icon) => ValidIcon(
        searchFields: List<String>.from(icon['tags']),
        codepoint: int.parse(icon['codepoint'].substring(2), radix: 16),
      ));
  return validIcons.toList();
}));
