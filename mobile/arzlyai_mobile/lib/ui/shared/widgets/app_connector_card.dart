import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class AppConnectorCard extends ConsumerWidget {
  const AppConnectorCard._({required this.connectorKey, super.key});

  factory AppConnectorCard.linkedin({Key? key}) {
    return AppConnectorCard._(connectorKey: ConnectorKeys.linkedin, key: key);
  }

  final String connectorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              BrandIcon.connector(connectorKey, size: context.iconLarge + 4),
              SizedBox(width: context.spaceSmall),
              Expanded(
                child: Text(
                  connectorSettingsLabel(connectorKey),
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.cardForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.spaceSmall),
          Text(
            connectorKey == ConnectorKeys.linkedin
                ? 'Direct LinkedIn OAuth is coming later. Daily LinkedIn AI Post cannot publish until it ships.'
                : connectorSettingsHint(connectorKey),
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          if (connectorKey == ConnectorKeys.linkedin) ...[
            SizedBox(height: context.spaceSmall),
            Text(
              'Coming later',
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
