// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAccountNamesHash() => r'd66af08b572f1b090e9d49ddd2be032b88be4e6c';

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
String _$otherAccountNamesHash() => r'65ba17095af480ab0547f4418db04b6238b0d4bb';

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
String _$accountsHash() => r'1a7394ad8e4314bd5557622e7c9ad208c8edf7dd';

/// See also [Accounts].
@ProviderFor(Accounts)
final accountsProvider =
    AsyncNotifierProvider<Accounts, Map<String, Account>>.internal(
  Accounts.new,
  name: r'accountsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Accounts = AsyncNotifier<Map<String, Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
