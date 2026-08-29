import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/credentials/credential_requirements_provider.dart';
import 'package:arzlyai_mobile/data/providers/settings/settings_provider.dart';
import 'package:arzlyai_mobile/domain/entities/credentials/credential_requirement.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_credential_field.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_text_field.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsControllerProvider);
    final requirements = ref.watch(credentialRequirementsProvider);
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Text('Backend', style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall),
          AppTextField.backendUrl(),
          SizedBox(height: context.spaceMedium),
          requirements.when(
            data: (items) {
              if (items.isEmpty) {
                return Text(
                  'Open a preset to load credential requirements.',
                  style: theme.textTheme.muted.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                );
              }
              final groups = <String, List<CredentialRequirement>>{};
              for (final item in items) {
                groups.putIfAbsent(item.groupKey, () => []).add(item);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: groups.entries.map((entry) {
                  final groupLabel = entry.value.first.groupLabel;
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.spaceMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(groupLabel, style: theme.textTheme.small),
                        SizedBox(height: context.spaceSmall),
                        ...entry.value.map(
                          (requirement) => Padding(
                            padding: EdgeInsets.only(bottom: context.spaceSmall),
                            child: AppCredentialField(
                              envelopeKey: requirement.envelopeKey,
                              label: requirement.label,
                              obscureText: requirement.obscure,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const AppScreenLoader(),
            error: (error, _) => Text(
              '$error',
              style: theme.textTheme.p.copyWith(color: theme.colorScheme.destructive),
            ),
          ),
          SizedBox(height: context.spaceLarge),
          AppButton.primary(
            label: 'Save',
            onPressed: () async {
              await ref.read(settingsControllerProvider.notifier).save();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
