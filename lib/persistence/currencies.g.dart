// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currenciesPersistenceHash() =>
    r'2603cbc10a560a78aacca1ac67307d24b65963a2';

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
