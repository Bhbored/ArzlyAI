import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/data/providers/geo/countries_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';
import 'package:arzlyai_mobile/domain/entities/geo/country.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';

class AppCountrySelect extends ConsumerWidget {
  const AppCountrySelect({
    required this.fieldKey,
    required this.label,
    super.key,
  });

  final String fieldKey;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final countriesAsync = ref.watch(countriesProvider);
    final selectedCode = ref.watch(runConfigTempProvider).inputs[fieldKey] ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: context.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.small),
          SizedBox(height: context.spaceSmall / 2),
          countriesAsync.when(
            loading: () => const AppScreenLoader(),
            error: (error, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$error', style: theme.textTheme.muted),
                AppButton.ghost(
                  label: 'Retry',
                  onPressed: () =>
                      ref.read(countriesProvider.notifier).refresh(),
                ),
              ],
            ),
            data: (countries) {
              final selected = _countryForCode(countries, selectedCode);
              return ShadButton.outline(
                width: double.infinity,
                onPressed: () => _openPicker(context, ref, countries),
                child: selected == null
                    ? Text(
                        selectedCode.isEmpty ? 'Select country' : selectedCode,
                        style: theme.textTheme.p,
                      )
                    : _CountryRow(country: selected, compact: true),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    WidgetRef ref,
    List<Country> countries,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _CountryPickerSheet(
        countries: countries,
        selectedCode: ref.read(runConfigTempProvider).inputs[fieldKey],
      ),
    );
    if (selected == null) return;
    final current = ref.read(runConfigTempProvider);
    final inputs = Map<String, String>.from(current.inputs)..[fieldKey] = selected;
    ref.read(runConfigTempProvider.notifier).update(
      current.copyWith(inputs: inputs),
    );
  }

  Country? _countryForCode(List<Country> countries, String code) {
    if (code.isEmpty) return null;
    return countries.where((country) => country.code == code).firstOrNull;
  }
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({
    required this.countries,
    required this.selectedCode,
  });

  final List<Country> countries;
  final String? selectedCode;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final filtered = _filteredCountries();
    final height = MediaQuery.sizeOf(context).height * 0.75;

    return SafeArea(
      child: SizedBox(
        height: height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.paddingMedium,
            0,
            context.paddingMedium,
            context.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Select country', style: theme.textTheme.h4),
              SizedBox(height: context.spaceSmall),
              ShadInput(
                placeholder: const Text('Search countries'),
                leading: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(LucideIcons.search, size: 16),
                ),
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
              SizedBox(height: context.spaceSmall),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No countries match your search.',
                          style: theme.textTheme.muted,
                        ),
                      )
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: context.spaceSmall / 2),
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final selected = country.code == widget.selectedCode;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                context.borderRadiusMedium,
                              ),
                              onTap: () =>
                                  Navigator.of(context).pop(country.code),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.paddingSmall,
                                  vertical: context.paddingSmall,
                                ),
                                child: _CountryRow(
                                  country: country,
                                  selected: selected,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Country> _filteredCountries() {
    if (_query.isEmpty) return widget.countries;
    final lower = _query.toLowerCase();
    return widget.countries
        .where(
          (country) =>
              country.name.toLowerCase().contains(lower) ||
              country.code.toLowerCase().contains(lower),
        )
        .toList(growable: false);
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({
    required this.country,
    this.compact = false,
    this.selected = false,
  });

  final Country country;
  final bool compact;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final flagHeight = compact ? 14.0 : 18.0;

    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.borderRadiusSmall / 2),
          child: Image.network(
            country.flagUrl,
            height: flagHeight,
            width: flagHeight * 1.5,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => SizedBox(
              height: flagHeight,
              width: flagHeight * 1.5,
              child: Icon(
                LucideIcons.flag,
                size: flagHeight,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ),
        ),
        SizedBox(width: context.spaceSmall),
        if (compact)
          Text(
            '${country.name} (${country.code})',
            style: theme.textTheme.p,
            overflow: TextOverflow.ellipsis,
          )
        else
          Expanded(
            child: Text(
              country.name,
              style: theme.textTheme.p,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (!compact) ...[
          SizedBox(width: context.spaceSmall),
          Text(
            country.code,
            style: theme.textTheme.muted.copyWith(
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
        if (selected) ...[
          SizedBox(width: context.spaceSmall),
          Icon(
            LucideIcons.check,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ],
      ],
    );
  }
}
