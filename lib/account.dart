import 'package:flutter_hello_world/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class Currency {
  const Currency({
    required this.decimals,
  });

  final int decimals;
}

Currency cad = const Currency(decimals: 2);

class Account with UniqueID {

  Account({
    required this.name,
    required this.currency,
    this.initialAmount = 0,
    this.personnal = false,
  });

  String name;
  double initialAmount;
  final Currency currency;
  bool personnal;
}

final Account wallet = Account(name: 'Wallet', currency: cad, initialAmount: 1000, personnal: true);
final Account viateurBagel = Account(name: "Viateur Bagel", currency: wallet.currency);
final Account starbucks = Account(name: "Starbucks", currency: wallet.currency);


class AccountManager extends StateNotifier<List<Account>> {
  AccountManager([List<Account>? initialAccounts]) : super(initialAccounts ?? []);

  Account? get(String name) =>  state.where((element) => element.name == name).firstOrNull;

  bool add(Account newAccount) {
    Account? existingAccount = get(newAccount.name);

    if (existingAccount != null) {
      return false;
    }

    state = [
      ...state,
      newAccount,
    ];

    return true;

  }


}


final accountsProvider = StateNotifierProvider<AccountManager, List<Account>>((ref) {
  return AccountManager([wallet, viateurBagel, starbucks]);
});


final myAccountNamesProvider = Provider<List<String>>((ref) {
  return ref.watch(accountsProvider).where((a) => a.personnal).map((a) => a.name).toList();
});


final otherAccountNamesProvider = Provider<List<String>>((ref) {
  return ref.watch(accountsProvider).where((a) => !a.personnal).map((a) => a.name).toList();
});
