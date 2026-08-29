import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/data/providers/temp/settings_credentials_temp.dart';

class AppCredentialField extends ConsumerWidget {
  const AppCredentialField({
    required this.envelopeKey,
    required this.label,
    this.obscureText = true,
    super.key,
  });

  final String envelopeKey;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value =
        ref
            .watch(settingsCredentialsTempProvider)
            .credentialValues[envelopeKey] ??
        '';
    return ShadInput(
      initialValue: value,
      placeholder: Text(label),
      obscureText: obscureText,
      onChanged: (next) {
        ref
            .read(settingsCredentialsTempProvider.notifier)
            .updateCredential(envelopeKey, next);
      },
    );
  }
}
