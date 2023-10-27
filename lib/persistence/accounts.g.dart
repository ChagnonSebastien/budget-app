// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsPersistenceHash() =>
    r'f3a7872fcca5f1dbc33024dc596793e6c3723c32';

/// See also [AccountsPersistence].
@ProviderFor(AccountsPersistence)
final accountsPersistenceProvider =
    AsyncNotifierProvider<AccountsPersistence, Database>.internal(
  AccountsPersistence.new,
  name: r'accountsPersistenceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsPersistenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountsPersistence = AsyncNotifier<Database>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
