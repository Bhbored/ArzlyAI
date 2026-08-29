// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(securityService)
final securityServiceProvider = SecurityServiceProvider._();

final class SecurityServiceProvider
    extends
        $FunctionalProvider<SecurityService, SecurityService, SecurityService>
    with $Provider<SecurityService> {
  SecurityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'securityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$securityServiceHash();

  @$internal
  @override
  $ProviderElement<SecurityService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecurityService create(Ref ref) {
    return securityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecurityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecurityService>(value),
    );
  }
}

String _$securityServiceHash() => r'2259560216db5b0bec537b7a1cd59a555c71395f';
