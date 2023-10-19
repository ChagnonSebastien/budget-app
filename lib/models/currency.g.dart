// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currenciesHash() => r'4f7496eb0cefc82b63c41524b45e1e0e7928097b';

/// See also [Currencies].
@ProviderFor(Currencies)
final currenciesProvider = AutoDisposeAsyncNotifierProvider<Currencies,
    Map<String, Currency>>.internal(
  Currencies.new,
  name: r'currenciesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currenciesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Currencies = AutoDisposeAsyncNotifier<Map<String, Currency>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
