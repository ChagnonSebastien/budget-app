// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsPersistenceHash() =>
    r'614d1702e4394690b908c03e1fae46934734f2e2';

/// See also [TransactionsPersistence].
@ProviderFor(TransactionsPersistence)
final transactionsPersistenceProvider =
    AsyncNotifierProvider<TransactionsPersistence, sql.Database>.internal(
  TransactionsPersistence.new,
  name: r'transactionsPersistenceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsPersistenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionsPersistence = AsyncNotifier<sql.Database>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
