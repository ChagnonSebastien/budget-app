import 'package:flutter_hello_world/models/savable.dart';
import 'package:flutter_hello_world/persistence/accounts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'account.g.dart';

class Account extends Savable {
  Account({
    String? uid,
    required this.name,
    this.initialAmount = 0,
    this.personal = false,
  }) {
    this.uid = uid ?? Uuid().v4();
  }

  @override
  late final String uid;

  String name;
  int initialAmount;
  final bool personal;
}

@Riverpod(keepAlive: true)
class Accounts extends _$Accounts {
  @override
  Future<Map<String, Account>> build() async {
    return getAll();
  }

  Future<bool> add(Account newAccount) async {
    final futureValue = await future;
    if (futureValue.containsKey(newAccount.uid)) {
      return false;
    }

    await ref.read(accountsPersistenceProvider.notifier).create(newAccount);

    state = AsyncData({
      ...futureValue,
      newAccount.uid: newAccount,
    });
    return true;
  }

  void reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      // removing the item at oldIndex will shorten the list by 1.
      newIndex -= 1;
    }

  }

  Future<Account> withName(String name, {Account? orElse}) async {
    final futureValue = await future;
    if (orElse == null) {
      return futureValue.values.firstWhere((element) => element.name == name);
    }
    return futureValue.values.firstWhere((element) => element.name == name, orElse: () => orElse,);
  }

  Future<Map<String, Account>> getAll() async {
    List<Account> items = await ref.read(accountsPersistenceProvider.notifier).readAll();
    return Map.fromEntries(items.map((e) => MapEntry(e.uid, e)));
  }

  Future<Function> factoryReset() async {
    await ref.read(accountsPersistenceProvider.notifier).deleteAll();

    return () async {
      await ref.read(accountsPersistenceProvider.notifier).populateData();
      state = AsyncData(await getAll());
    };
  }
}

@riverpod
Future<List<String>> myAccountNames(MyAccountNamesRef ref) async {
  final accounts = await ref.watch(accountsProvider.future);
  return accounts.values.where((a) => a.personal).map((a) => a.name).toList();
}

@riverpod
Future<List<String>> otherAccountNames(OtherAccountNamesRef ref) async {
  final accounts = await ref.watch(accountsProvider.future);
  return accounts.values.where((a) => !a.personal).map((a) => a.name).toList();
}
