import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/persistance/persistance.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class Account extends Savable {

  Account({
    required this.name,
    this.initialAmount = 0,
    this.personal = false,
  });

  @override
  String get id => name;

  String name;
  int initialAmount;
  bool personal;
}

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
  return AccountManager(Defaults.accounts.asList());
});


final myAccountNamesProvider = Provider<List<String>>((ref) {
  return ref.watch(accountsProvider).where((a) => a.personal).map((a) => a.name).toList();
});


final otherAccountNamesProvider = Provider<List<String>>((ref) {
  return ref.watch(accountsProvider).where((a) => !a.personal).map((a) => a.name).toList();
});
