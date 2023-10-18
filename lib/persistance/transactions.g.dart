// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsPersistanceHash() =>
    r'f7fce2d1d0aa118b3b4f82e79f23ab41fca6b99f';

/// See also [TransactionsPersistance].
@ProviderFor(TransactionsPersistance)
final transactionsPersistanceProvider =
    AsyncNotifierProvider<TransactionsPersistance, sql.Database>.internal(
  TransactionsPersistance.new,
  name: r'transactionsPersistanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsPersistanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionsPersistance = AsyncNotifier<sql.Database>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
