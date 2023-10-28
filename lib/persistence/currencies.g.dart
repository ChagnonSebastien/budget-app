// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currenciesPersistenceHash() =>
    r'a274b633aae84296a64dd9de84737cc9e9a1f339';

/// See also [CurrenciesPersistence].
@ProviderFor(CurrenciesPersistence)
final currenciesPersistenceProvider =
    AsyncNotifierProvider<CurrenciesPersistence, Database>.internal(
  CurrenciesPersistence.new,
  name: r'currenciesPersistenceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currenciesPersistenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrenciesPersistence = AsyncNotifier<Database>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
