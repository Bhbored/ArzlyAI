import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset.dart';
import 'package:arzlyai_mobile/domain/entities/preset/preset_support.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class AppIntegrationCard extends StatelessWidget {
  const AppIntegrationCard({required this.integration, super.key});

  final IntegrationRequirement integration;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final credentialType = humanizePresetToken(
      _credentialTypeRaw(integration.credentialSchemaJson),
    );

    return AppCard.standard(
      title: integration.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            integration.description,
            style: theme.textTheme.p.copyWith(
              color: theme.colorScheme.cardForeground,
            ),
          ),
          SizedBox(height: context.spaceSmall),
          _DetailRow(label: 'Integration key', value: integration.key),
          SizedBox(height: context.spaceSmall),
          _DetailRow(label: 'Credential type', value: credentialType),
          SizedBox(height: context.spaceSmall),
          Text(
            integrationSettingsHint(integration.key),
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  static String _credentialTypeRaw(String schemaJson) {
    try {
      final map = jsonDecode(schemaJson) as Map<String, dynamic>;
      final type = map['type'];
      if (type is String && type.isNotEmpty) return type;
    } catch (_) {}
    return 'credentials';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.spaceSmall / 4),
        Text(
          value,
          style: theme.textTheme.small.copyWith(
            color: theme.colorScheme.cardForeground,
          ),
        ),
      ],
    );
  }
}
