// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currenciesPersistanceHash() =>
    r'b3c25679d46348973310b9c6253a1142eace1d0e';

/// See also [CurrenciesPersistance].
@ProviderFor(CurrenciesPersistance)
final currenciesPersistanceProvider =
    AsyncNotifierProvider<CurrenciesPersistance, Database>.internal(
  CurrenciesPersistance.new,
  name: r'currenciesPersistanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currenciesPersistanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrenciesPersistance = AsyncNotifier<Database>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter