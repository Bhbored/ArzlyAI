// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_credentials_temp.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsCredentialsTemp)
final settingsCredentialsTempProvider = SettingsCredentialsTempProvider._();

final class SettingsCredentialsTempProvider
    extends
        $NotifierProvider<SettingsCredentialsTemp, SettingsCredentialsState> {
  SettingsCredentialsTempProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsCredentialsTempProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsCredentialsTempHash();

  @$internal
  @override
  SettingsCredentialsTemp create() => SettingsCredentialsTemp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsCredentialsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsCredentialsState>(value),
    );
  }
}

String _$settingsCredentialsTempHash() =>
    r'b3fd8cd6cd22fdfe8e8c6ecacaa4f0995672ab5e';

abstract class _$SettingsCredentialsTemp
    extends $Notifier<SettingsCredentialsState> {
  SettingsCredentialsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<SettingsCredentialsState, SettingsCredentialsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsCredentialsState, SettingsCredentialsState>,
              SettingsCredentialsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
