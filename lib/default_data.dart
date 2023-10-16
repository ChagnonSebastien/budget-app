import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';

class Defaults {
  static Categories? _categories;

  static Categories get categories {
    _categories ??= Categories();
    return _categories!;
  }

  static Currencies? _currencies;

  static Currencies get currencies {
    _currencies ??= Currencies();
    return _currencies!;
  }

  static Accounts? _accounts;

  static Accounts get accounts {
    _accounts ??= Accounts();
    return _accounts!;
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

class Currencies {
  final Currency cad = Currency(name: 'CAD', decimals: 2, symbol: '\$', showSymbolBeforeAmount: true);
  final Currency aapl = Currency(name: 'Apple Share', decimals: 4, symbol: 'AAPL', showSymbolBeforeAmount: false);

  List<Currency> asList() {
    return [cad, aapl];
  }
}

class Accounts {
  final Account wallet = Account(name: 'Wallet', initialAmount: 10000, personal: true);
  final Account checking = Account(name: 'Checking Account', initialAmount: 200000, personal: true);
  final Account viateurBagel = Account(name: "Viateur Bagel");
  final Account starbucks = Account(name: "Starbucks");
  final Account randolph = Account(name: "Randolph");
  final Account maxi = Account(name: "Maxi");

  List<Account> asList() {
    return [
      wallet,
      checking,
      viateurBagel,
      starbucks,
      randolph,
      maxi,
    ];
  }
}
