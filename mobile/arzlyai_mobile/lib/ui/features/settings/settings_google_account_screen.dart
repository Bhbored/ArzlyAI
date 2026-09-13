import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/core/constants/app_sizes.dart';
import 'package:arzlyai_mobile/core/credentials/connector_integration_support.dart';
import 'package:arzlyai_mobile/core/credentials/connector_keys.dart';
import 'package:arzlyai_mobile/data/providers/google/google_auth_provider.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_auth_cache.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_auth_state_store.dart';
import 'package:arzlyai_mobile/data/repositories/google/google_native_auth_repository.dart';
import 'package:arzlyai_mobile/ui/features/settings/widgets/settings_grouped_list.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_button.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_card.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/app_loading.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';

class SettingsGoogleAccountScreen extends ConsumerStatefulWidget {
  const SettingsGoogleAccountScreen({super.key});

  @override
  ConsumerState<SettingsGoogleAccountScreen> createState() =>
      _SettingsGoogleAccountScreenState();
}

class _SettingsGoogleAccountScreenState
    extends ConsumerState<SettingsGoogleAccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_refreshGoogleAuth());
    });
  }

  Future<void> _refreshGoogleAuth() async {
    final notifier = ref.read(googleAuthProvider.notifier);
    final repository = ref.read(googleNativeAuthRepositoryProvider);
    final stateStore = ref.read(googleAuthStateStoreProvider);
    final cached = await stateStore.read();
    notifier.update(
      GoogleAuthState(
        accountEmail: cached?.accountEmail,
        accountDisplayName: cached?.accountDisplayName,
        authorizedConnectors: cached?.authorizedConnectors ?? const {},
        isLoading: true,
      ),
    );
    await _runRefresh(notifier, repository, stateStore);
  }

  Future<void> _signInWithGoogle() async {
    final notifier = ref.read(googleAuthProvider.notifier);
    final repository = ref.read(googleNativeAuthRepositoryProvider);
    final stateStore = ref.read(googleAuthStateStoreProvider);
    final current = ref.read(googleAuthProvider);
    notifier.update(current.copyWith(isBusy: true, clearError: true));
    try {
      await repository.ensureSignedIn();
      await _runRefresh(notifier, repository, stateStore);
    } catch (error) {
      notifier.update(
        current.copyWith(
          isBusy: false,
          errorMessage: _googleAuthMessage(error),
        ),
      );
    }
  }

  Future<void> _disconnectGoogle() async {
    final notifier = ref.read(googleAuthProvider.notifier);
    final repository = ref.read(googleNativeAuthRepositoryProvider);
    final stateStore = ref.read(googleAuthStateStoreProvider);
    final current = ref.read(googleAuthProvider);
    notifier.update(current.copyWith(isBusy: true, clearError: true));
    try {
      await repository.disconnect();
      await stateStore.clear();
      ref.invalidate(googleAuthCacheProvider);
      notifier.clear();
    } catch (error) {
      notifier.update(
        current.copyWith(
          isBusy: false,
          errorMessage: _googleAuthMessage(error),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final auth = ref.watch(googleAuthProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Google account', style: theme.textTheme.h4)),
      body: AppLoadingOverlay(
        visible: auth.isLoading || auth.isBusy,
        child: ListView(
          padding: EdgeInsets.all(context.paddingMedium),
          children: [
            Text(
              'One Google account powers Sheets, Gmail, Tasks, and Calendar. '
              'Authorize each service when you need it. Tokens stay on this device '
              'and are sent to the backend only inside encrypted envelopes.',
              style: theme.textTheme.muted.copyWith(
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            SizedBox(height: context.spaceMedium),
            AppCard.standard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      BrandIcon.connector(
                        ConnectorKeys.googleSheets,
                        size: context.iconLarge + 4,
                      ),
                      SizedBox(width: context.spaceSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.accountLabel,
                              style: theme.textTheme.small.copyWith(
                                color: theme.colorScheme.cardForeground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _accountSubtitle(auth),
                              style: theme.textTheme.muted.copyWith(
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spaceSmall),
                  if (!auth.isSignedIn || auth.requiresReconnect)
                    AppButton.primary(
                      label: auth.isBusy
                          ? 'Signing in…'
                          : 'Sign in with Google',
                      onPressed: auth.isBusy ? null : _signInWithGoogle,
                    )
                  else
                    AppButton.destructive(
                      label: 'Disconnect Google account',
                      onPressed: auth.isBusy ? null : _disconnectGoogle,
                    ),
                ],
              ),
            ),
            if (auth.errorMessage != null) ...[
              SizedBox(height: context.spaceSmall),
              Text(
                auth.errorMessage!,
                style: theme.textTheme.muted.copyWith(
                  color: theme.colorScheme.destructive,
                ),
              ),
            ],
            SizedBox(height: context.spaceMedium),
            SettingsGroupedList(
              dividerIndent: context.paddingMedium + 40 + context.spaceSmall,
              children: [
                for (final connectorKey in ConnectorKeys.googleConnectors)
                  _ServiceRow(connectorKey: connectorKey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends ConsumerWidget {
  const _ServiceRow({required this.connectorKey});

  final String connectorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(googleAuthProvider);
    final authorized = auth.isConnectorAuthorized(connectorKey);
    return SettingsListRow(
      leading: BrandIcon.connector(connectorKey),
      title: connectorSettingsLabel(connectorKey),
      subtitle: _connectorSubtitle(auth, authorized),
      trailing: auth.isSignedIn && !authorized
          ? AppButton.ghost(
              label: auth.isBusy ? '…' : 'Authorize',
              onPressed: auth.isBusy
                  ? null
                  : () => _authorizeGoogleService(ref, connectorKey),
            )
          : null,
      showChevron: false,
      onTap: () {
        if (auth.isSignedIn && !authorized && !auth.isBusy) {
          _authorizeGoogleService(ref, connectorKey);
        }
      },
    );
  }
}

Future<void> _authorizeGoogleService(WidgetRef ref, String connectorKey) async {
  final notifier = ref.read(googleAuthProvider.notifier);
  final repository = ref.read(googleNativeAuthRepositoryProvider);
  final stateStore = ref.read(googleAuthStateStoreProvider);
  final current = ref.read(googleAuthProvider);
  notifier.update(current.copyWith(isBusy: true, clearError: true));
  try {
    await repository.authorizeConnector(connectorKey);
    await _runRefresh(notifier, repository, stateStore);
  } catch (error) {
    notifier.update(
      current.copyWith(isBusy: false, errorMessage: _googleAuthMessage(error)),
    );
  }
}

Future<void> _runRefresh(
  GoogleAuthNotifier notifier,
  GoogleNativeAuthRepository repository,
  GoogleAuthStateStore stateStore,
) async {
  try {
    await repository.restoreSilently();
    final account = repository.currentAccount;
    if (account == null) {
      final cached = await stateStore.read();
      notifier.update(
        GoogleAuthState(
          accountEmail: cached?.accountEmail,
          accountDisplayName: cached?.accountDisplayName,
          authorizedConnectors: cached?.authorizedConnectors ?? const {},
          requiresReconnect: cached != null,
        ),
      );
      return;
    }
    final authorized = <String>{};
    for (final connectorKey in ConnectorKeys.googleConnectors) {
      if (await repository.isAuthorized(connectorKey)) {
        authorized.add(connectorKey);
      }
    }
    final cache = GoogleAuthCache(
      accountEmail: account.email,
      accountDisplayName: account.displayName,
      authorizedConnectors: authorized,
    );
    await stateStore.save(cache);
    notifier.update(
      GoogleAuthState(
        accountEmail: cache.accountEmail,
        accountDisplayName: cache.accountDisplayName,
        authorizedConnectors: cache.authorizedConnectors,
      ),
    );
  } catch (error) {
    final cached = await stateStore.read();
    notifier.update(
      GoogleAuthState(
        accountEmail: cached?.accountEmail,
        accountDisplayName: cached?.accountDisplayName,
        authorizedConnectors: cached?.authorizedConnectors ?? const {},
        errorMessage: _googleAuthMessage(error),
      ),
    );
  }
}

String _accountSubtitle(GoogleAuthState auth) {
  if (auth.requiresReconnect) return 'Session expired · Sign in again';
  if (auth.isLoading && auth.isSignedIn) {
    return 'Connected on this device · Verifying…';
  }
  if (auth.isLoading) return 'Checking saved account…';
  if (auth.isSignedIn) return 'Account connected on this device';
  return 'Sign in to authorize Google services';
}

String _connectorSubtitle(GoogleAuthState auth, bool authorized) {
  if (auth.requiresReconnect) return 'Reconnect Google account';
  if (auth.isLoading && authorized) return 'Authorized · Verifying…';
  if (auth.isLoading) return 'Checking authorization…';
  if (!auth.isSignedIn) return 'Sign in first';
  return authorized ? 'Authorized' : 'Not authorized';
}

String _googleAuthMessage(Object error) {
  if (error is GoogleSignInException) {
    if (error.code == GoogleSignInExceptionCode.canceled) {
      return 'Google authorization was cancelled.';
    }
    return error.description ?? 'Google authorization failed.';
  }
  return error.toString();
}
