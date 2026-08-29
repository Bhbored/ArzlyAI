// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_requirements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(credentialRequirements)
final credentialRequirementsProvider = CredentialRequirementsProvider._();

final class CredentialRequirementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CredentialRequirement>>,
          List<CredentialRequirement>,
          FutureOr<List<CredentialRequirement>>
        >
    with
        $FutureModifier<List<CredentialRequirement>>,
        $FutureProvider<List<CredentialRequirement>> {
  CredentialRequirementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: retry,
        name: r'credentialRequirementsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$credentialRequirementsHash();

  @$internal
  @override
  $FutureProviderElement<List<CredentialRequirement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CredentialRequirement>> create(Ref ref) {
    return credentialRequirements(ref);
  }
}

String _$credentialRequirementsHash() =>
    r'f19e7290c1685476079994ac12da927fb8282aeb';
