import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';
import 'package:flutter_hello_world/models/category.dart';
import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/models/transaction.dart';

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

  static Transactions? _transactions;

  static Transactions get transactions {
    _transactions ??= Transactions();
    return _transactions!;
  }
}

class Categories {
  Categories() {
    food.parent = any.uid;
    groceries.parent = food.uid;
    fastFood.parent = food.uid;
    goingOut.parent = food.uid;
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
    iconColor: const Color.fromARGB(255, 192, 162, 41),
  );

  final Category groceries = Category(
    name: 'Groceries',
    codepoint: Icons.shopping_basket.codePoint,
    iconColor: const Color.fromARGB(255, 6, 79, 8),
  );

  final Category fastFood = Category(
    name: 'Fast food',
    codepoint: Icons.fastfood.codePoint,
    iconColor: const Color.fromARGB(255, 147, 40, 40),
  );

  final Category goingOut = Category(
    name: 'Restaurant',
    codepoint: Icons.restaurant.codePoint,
    iconColor: const Color.fromARGB(255, 140, 143, 157),
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
  final Account wallet = Account(name: 'Wallet', personal: true);
  final Account checking = Account(name: 'Checking Account', personal: true);
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

class Transactions {
  List<Transaction> asList() {
    return [
      Transaction(
        amount: 15 * 1000 * 100,
        currency: Defaults.currencies.cad,
        to: Defaults.accounts.checking,
        date: DateTime.fromMillisecondsSinceEpoch(0),
      ),
      Transaction(
        amount: 325,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.wallet,
        to: Defaults.accounts.starbucks,
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: Defaults.categories.fastFood,
        note: 'Coffee',
      ),
      Transaction(
        amount: 14689,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.checking,
        to: Defaults.accounts.maxi,
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: Defaults.categories.groceries,
      ),
      Transaction(
        amount: 325,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.wallet,
        to: Defaults.accounts.randolph,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: Defaults.categories.goingOut,
        note: 'Fete de Pierre',
      ),
      Transaction(
        amount: 1020,
        currency: Defaults.currencies.cad,
        from: Defaults.accounts.checking,
        to: Defaults.accounts.viateurBagel,
        date: DateTime.now(),
        category: Defaults.categories.fastFood,
        note: 'Bagels',
      ),
    ];
  }
}
