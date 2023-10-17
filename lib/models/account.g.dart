// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAccountNamesHash() => r'95439fda713fb1d805c9378d5fbe7151199971e8';

/// See also [myAccountNames].
@ProviderFor(myAccountNames)
final myAccountNamesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  myAccountNames,
  name: r'myAccountNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myAccountNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyAccountNamesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$otherAccountNamesHash() => r'da3856cc44a506f9fdd7272346eaf7a9702cc45f';

/// See also [otherAccountNames].
@ProviderFor(otherAccountNames)
final otherAccountNamesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  otherAccountNames,
  name: r'otherAccountNamesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$otherAccountNamesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OtherAccountNamesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$accountsHash() => r'3db1a21a39cc3039e40c0d29ef39e6f90d7b612f';

/// See also [Accounts].
@ProviderFor(Accounts)
final accountsProvider =
    AutoDisposeAsyncNotifierProvider<Accounts, List<Account>>.internal(
  Accounts.new,
  name: r'accountsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Accounts = AutoDisposeAsyncNotifier<List<Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
