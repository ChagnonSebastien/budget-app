// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsPersistanceHash() =>
    r'39e1c105c262a316d3a1395d74be5bd785df47c0';

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
