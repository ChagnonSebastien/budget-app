// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsPersistenceHash() =>
    r'0514910f7d4c9a186599021df475034cd4a828de';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter