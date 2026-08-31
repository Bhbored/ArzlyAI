import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_connector_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsGoogleTasksConnectorScreen extends StatelessWidget {
  const SettingsGoogleTasksConnectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Google Tasks', style: theme.textTheme.h4)),
      body: ListView(
        padding: EdgeInsets.all(context.paddingMedium),
        children: [
          Row(
            children: [
              BrandIcon.google(size: 52),
              SizedBox(width: context.spaceSmall),
              Expanded(
                child: Text(
                  'Create tasks and subtasks after you approve a brain dump plan.',
                  style: theme.textTheme.muted.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.spaceMedium),
          AppConnectorCard.googleTasks(compact: true),
        ],
      ),
    );
  }
}
