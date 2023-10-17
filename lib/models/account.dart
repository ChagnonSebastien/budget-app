import 'package:flutter_hello_world/default_data.dart';
import 'package:flutter_hello_world/models/savable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account.g.dart';

class Account extends Savable {
  Account({
    required this.name,
    this.initialAmount = 0,
    this.personal = false,
  });

  @override
  String get uid => name;

  String name;
  int initialAmount;
  bool personal;
}

@riverpod
class Accounts extends _$Accounts {
  @override
  Future<List<Account>> build() async {
    return Defaults.accounts.asList();
  }

  Future<Account?> get(String name) async {
    return (await future).where((element) => element.name == name).firstOrNull;
  }

  Future<bool> add(Account newAccount) async {
    if (await get(newAccount.name) != null) {
      return false;
    }

    final futureValue = await future;
    state = AsyncData([...futureValue, newAccount]);
    return true;
  }

  void reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }

    final futureValue = await future;
    final Account element = futureValue.removeAt(oldIndex);
    futureValue.insert(newIndex, element);
    state = AsyncData([...futureValue]);
  }
}

@riverpod
Future<List<String>> myAccountNames(MyAccountNamesRef ref) async {
  final accounts = await ref.watch(accountsProvider.future);
  return accounts.where((a) => a.personal).map((a) => a.name).toList();
}

@riverpod
Future<List<String>> otherAccountNames(OtherAccountNamesRef ref) async {
  final accounts = await ref.watch(accountsProvider.future);
  return accounts.where((a) => !a.personal).map((a) => a.name).toList();
}
