// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$materialIconDataHash() => r'7be40f1e8becaa76cfd94ae8e041b3f356084469';

/// See also [materialIconData].
@ProviderFor(materialIconData)
final materialIconDataProvider =
    AutoDisposeFutureProvider<List<ValidIcon>>.internal(
  materialIconData,
  name: r'materialIconDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$materialIconDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MaterialIconDataRef = AutoDisposeFutureProviderRef<List<ValidIcon>>;
String _$categoriesHash() => r'4816d6f4d7140235c4da33fc16d0b3d656e211f2';

/// See also [Categories].
@ProviderFor(Categories)
final categoriesProvider =
    AsyncNotifierProvider<Categories, Map<String, Category>>.internal(
  Categories.new,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Categories = AsyncNotifier<Map<String, Category>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
