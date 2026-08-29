import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_credentials_temp.freezed.dart';
part 'settings_credentials_temp.g.dart';

@freezed
sealed class SettingsCredentialsState with _$SettingsCredentialsState {
  const factory SettingsCredentialsState({
    @Default({}) Map<String, String> credentialValues,
  }) = _SettingsCredentialsState;
}

@Riverpod()
class SettingsCredentialsTemp extends _$SettingsCredentialsTemp {
  @override
  SettingsCredentialsState build() => const SettingsCredentialsState();

  void update(SettingsCredentialsState next) => state = next;

  void clear() => state = const SettingsCredentialsState();

  void updateCredential(String envelopeKey, String value) {
    state = state.copyWith(
      credentialValues: {...state.credentialValues, envelopeKey: value},
    );
  }
}
