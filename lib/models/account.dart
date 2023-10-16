import 'dart:math';

import 'package:flutter_hello_world/models/currency.dart';
import 'package:flutter_hello_world/persistance/persistance.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class Account extends Savable {

  Account({
    required this.name,
    required this.currency,
    this.initialAmount = 0,
    this.personal = false,
  });

  @override
  String get id => name;

  String name;
  int initialAmount;
  final Currency currency;
  bool personal;

  String formatValue(int amount) {
    return (amount / pow(10, currency.decimals)).toStringAsFixed(currency.decimals);
  }
}

final Account wallet = Account(name: 'Wallet', currency: cad, initialAmount: 10000, personal: true);
final Account checking = Account(name: 'Checking Account', currency: cad, initialAmount: 200000, personal: true);
final Account viateurBagel = Account(name: "Viateur Bagel", currency: wallet.currency);
final Account starbucks = Account(name: "Starbucks", currency: wallet.currency);
final Account randolph = Account(name: "Randolph", currency: wallet.currency);
final Account maxi = Account(name: "Maxi", currency: wallet.currency);


class AccountManager extends StateNotifier<List<Account>> {
  AccountManager([List<Account>? initialAccounts]) : super(initialAccounts ?? []);

  Account? get(String name) =>  state.where((element) => element.name == name).firstOrNull;

  bool add(Account newAccount) {
    if (get(newAccount.name) != null) {
      return false;
    }

    state = [...state, newAccount,];
    return true;
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }

    final Account element = state.removeAt(oldIndex);
    state.insert(newIndex, element);
    state = [...state];
  }
}


final accountsProvider = StateNotifierProvider<AccountManager, List<Account>>((ref) {
  return AccountManager([wallet, checking, viateurBagel, starbucks, randolph, maxi]);
});


final myAccountNamesProvider = Provider<List<String>>((ref) {
  return ref.watch(accountsProvider).where((a) => a.personal).map((a) => a.name).toList();
});


final otherAccountNamesProvider = Provider<List<String>>((ref) {
  return ref.watch(accountsProvider).where((a) => !a.personal).map((a) => a.name).toList();
});
