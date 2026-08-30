import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_connector_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsLinkedInConnectorScreen extends ConsumerWidget {
  const SettingsLinkedInConnectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('LinkedIn', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Row(
            children: [
              BrandIcon.linkedin(size: 52),
              SizedBox(width: context.spaceSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LinkedIn connector',
                      style: theme.textTheme.p.copyWith(
                        color: theme.colorScheme.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'OAuth tokens stay on this device.',
                      style: theme.textTheme.muted.copyWith(
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.spaceMedium),
          Text(
            'Authorize through LinkedIn in your browser. ArzlyAI uses Nango to broker OAuth — access tokens stay on your device.',
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          SizedBox(height: context.spaceMedium),
          AppConnectorCard.linkedin(compact: true),
        ],
      ),
    );
  }
}
