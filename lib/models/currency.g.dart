// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currencyHash() => r'9df76ccd2dcea9600c99300aedb248748cc4aeff';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [currency].
@ProviderFor(currency)
const currencyProvider = CurrencyFamily();

/// See also [currency].
class CurrencyFamily extends Family<AsyncValue<Currency>> {
  /// See also [currency].
  const CurrencyFamily();

  /// See also [currency].
  CurrencyProvider call(
    String id,
  ) {
    return CurrencyProvider(
      id,
    );
  }

  @visibleForOverriding
  @override
  CurrencyProvider getProviderOverride(
    covariant CurrencyProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'currencyProvider';
}

/// See also [currency].
class CurrencyProvider extends AutoDisposeFutureProvider<Currency> {
  /// See also [currency].
  CurrencyProvider(
    String id,
  ) : this._internal(
          (ref) => currency(
            ref as CurrencyRef,
            id,
          ),
          from: currencyProvider,
          name: r'currencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currencyHash,
          dependencies: CurrencyFamily._dependencies,
          allTransitiveDependencies: CurrencyFamily._allTransitiveDependencies,
          id: id,
        );

  CurrencyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Currency> Function(CurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrencyProvider._internal(
        (ref) => create(ref as CurrencyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Currency> createElement() {
    return _CurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrencyProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrencyRef on AutoDisposeFutureProviderRef<Currency> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CurrencyProviderElement
    extends AutoDisposeFutureProviderElement<Currency> with CurrencyRef {
  _CurrencyProviderElement(super.provider);

  @override
  String get id => (origin as CurrencyProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
