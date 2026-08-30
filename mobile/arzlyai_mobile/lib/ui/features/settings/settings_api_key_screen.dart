import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/credential_envelope_keys.dart';
import 'package:arzlyai_mobile/core/network/dto/response/models/provider_response.dart';
import 'package:arzlyai_mobile/data/providers/settings/settings_provider.dart';
import 'package:arzlyai_mobile/data/providers/temp/settings_credentials_temp.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/ai_provider_brand.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_toast.dart';

class SettingsApiKeyScreen extends ConsumerStatefulWidget {
  const SettingsApiKeyScreen({required this.provider, super.key});

  final ProviderResponse provider;

  @override
  ConsumerState<SettingsApiKeyScreen> createState() =>
      _SettingsApiKeyScreenState();
}

class _SettingsApiKeyScreenState extends ConsumerState<SettingsApiKeyScreen> {
  var _visible = false;
  var _saving = false;
  var _loadedValue = '';
  var _draftValue = '';

  String get _envelopeKey =>
      providerCredentialEnvelopeKey(widget.provider.key);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reloadFromSecureStorage());
  }

  Future<void> _reloadFromSecureStorage() async {
    await ref.read(settingsControllerProvider.notifier).reloadCredentials();
    if (!mounted) return;
    final stored =
        ref.read(settingsCredentialsTempProvider).credentialValues[_envelopeKey] ??
        '';
    setState(() {
      _loadedValue = stored;
      _draftValue = stored;
    });
  }

  bool get _dirty => _draftValue.trim() != _loadedValue.trim();

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      ref
          .read(settingsCredentialsTempProvider.notifier)
          .updateCredential(_envelopeKey, _draftValue.trim());
      await ref.read(settingsControllerProvider.notifier).save();
      if (!mounted) return;
      setState(() => _loadedValue = _draftValue.trim());
      ShadToaster.of(context).show(
        ShadToast(
          title: const Text('Key saved'),
          description: Text('${widget.provider.displayName} API key updated'),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      AppToast.errorFor(context, error, title: 'Save failed');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _clear() async {
    if (_saving || (_loadedValue.isEmpty && _draftValue.isEmpty)) return;
    setState(() => _saving = true);
    try {
      setState(() {
        _draftValue = '';
        _visible = false;
      });
      ref
          .read(settingsCredentialsTempProvider.notifier)
          .updateCredential(_envelopeKey, '');
      await ref.read(settingsControllerProvider.notifier).save();
      if (!mounted) return;
      setState(() => _loadedValue = '');
      ShadToaster.of(context).show(
        ShadToast(
          title: const Text('Key cleared'),
          description: Text(
            '${widget.provider.displayName} API key removed from secure storage',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      AppToast.errorFor(context, error, title: 'Clear failed');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(settingsControllerProvider).isLoading;
    final theme = ShadTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.provider.displayName, style: theme.textTheme.h4),
      ),
      body: loading && _loadedValue.isEmpty && _draftValue.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(context.paddingMedium),
              children: [
                Row(
                  children: [
                    AiProviderBrand(providerKey: widget.provider.key, size: 52),
                    SizedBox(width: context.spaceSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.provider.displayName} API key',
                            style: theme.textTheme.p.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Loaded from secure storage on this device.',
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
                Text('API key', style: theme.textTheme.small),
                SizedBox(height: context.spaceSmall / 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ShadInput(
                        key: ValueKey('$_envelopeKey-$_draftValue'),
                        initialValue: _draftValue,
                        placeholder: const Text('sk-…'),
                        obscureText: !_visible,
                        onChanged: (value) => setState(() => _draftValue = value),
                      ),
                    ),
                    SizedBox(width: context.spaceSmall / 2),
                    ShadButton.ghost(
                      onPressed: () => setState(() => _visible = !_visible),
                      child: Icon(
                        _visible ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: context.iconMedium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.spaceSmall),
                Text(
                  _loadedValue.isEmpty
                      ? 'No key saved yet. Paste a key and save to unlock models for this provider.'
                      : 'Replace the key above to rotate credentials, or clear to remove it from this device.',
                  style: theme.textTheme.muted.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                SizedBox(height: context.spaceLarge),
                AppButton.primary(
                  label: _saving ? 'Saving…' : 'Save key',
                  onPressed: !_dirty || _saving ? null : _save,
                ),
                SizedBox(height: context.spaceSmall),
                AppButton.ghost(
                  label: _saving ? 'Clearing…' : 'Clear key',
                  onPressed: _saving ||
                          (_loadedValue.isEmpty && _draftValue.isEmpty)
                      ? null
                      : _clear,
                ),
              ],
            ),
    );
  }
}
