import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/connectors/google_resource_providers.dart';
import 'package:arzlyai_mobile/data/providers/temp/google_sheet_selection_temp.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';

class AppGoogleSheetSelector extends ConsumerWidget {
  const AppGoogleSheetSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final selection = ref.watch(googleSheetSelectionTempProvider);
    final spreadsheets = ref.watch(googleSpreadsheetsProvider);
    final tabs = selection.spreadsheetId == null
        ? null
        : ref.watch(googleSheetTabsProvider(selection.spreadsheetId!));
    final headers =
        selection.spreadsheetId == null || selection.tabTitle == null
        ? null
        : ref.watch(
            googleSheetHeadersProvider((
              spreadsheetId: selection.spreadsheetId!,
              tabTitle: selection.tabTitle!,
            )),
          );

    return AppCard.standard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Google Sheets metadata',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.cardForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.spaceSmall),
          _SelectField(
            label: 'Spreadsheet',
            value: selection.spreadsheetId,
            placeholder: spreadsheets.isLoading
                ? 'Loading spreadsheets…'
                : 'Select a spreadsheet',
            enabled: spreadsheets.hasValue,
            options: [
              for (final spreadsheet in spreadsheets.value ?? const [])
                (value: spreadsheet.id, label: spreadsheet.name),
            ],
            onChanged: (value) {
              ref
                  .read(googleSheetSelectionTempProvider.notifier)
                  .update(
                    selection.copyWith(
                      spreadsheetId: value,
                      clearTab: true,
                      clearHeader: true,
                    ),
                  );
            },
          ),
          SizedBox(height: context.spaceSmall),
          _SelectField(
            label: 'Tab',
            value: selection.tabTitle,
            placeholder: tabs?.isLoading ?? false
                ? 'Loading tabs…'
                : 'Select a tab',
            enabled: tabs?.hasValue ?? false,
            options: [
              for (final tab in tabs?.value ?? const [])
                (value: tab.title, label: tab.title),
            ],
            onChanged: (value) {
              ref
                  .read(googleSheetSelectionTempProvider.notifier)
                  .update(
                    selection.copyWith(tabTitle: value, clearHeader: true),
                  );
            },
          ),
          SizedBox(height: context.spaceSmall),
          _SelectField(
            label: 'Header',
            value: selection.header,
            placeholder: headers?.isLoading ?? false
                ? 'Loading headers…'
                : 'Select a header',
            enabled: headers?.hasValue ?? false,
            options: [
              for (final header in headers?.value?.values ?? const <String>[])
                (value: header, label: header),
            ],
            onChanged: (value) {
              ref
                  .read(googleSheetSelectionTempProvider.notifier)
                  .update(selection.copyWith(header: value));
            },
          ),
          if (spreadsheets.hasError ||
              (tabs?.hasError ?? false) ||
              (headers?.hasError ?? false)) ...[
            SizedBox(height: context.spaceSmall),
            Text(
              'Could not load Google Sheets metadata.',
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.enabled,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final String placeholder;
  final bool enabled;
  final List<({String value, String label})> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textTheme.muted.copyWith(
            color: theme.colorScheme.foreground,
          ),
        ),
        SizedBox(height: context.spaceSmall),
        ShadSelect<String>(
          enabled: enabled,
          initialValue: value,
          placeholder: Text(placeholder),
          selectedOptionBuilder: (context, selected) {
            return Text(
              options
                      .where((option) => option.value == selected)
                      .map((option) => option.label)
                      .firstOrNull ??
                  selected,
            );
          },
          onChanged: (next) {
            if (next != null) onChanged(next);
          },
          options: [
            for (final option in options)
              ShadOption(value: option.value, child: Text(option.label)),
          ],
        ),
      ],
    );
  }
}
