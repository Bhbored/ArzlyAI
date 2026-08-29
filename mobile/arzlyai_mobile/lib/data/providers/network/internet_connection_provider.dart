import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/core/utilities/internet_connection_helper.dart';

part 'internet_connection_provider.g.dart';

@Riverpod(keepAlive: true)
InternetConnectionHelper internetConnectionHelper(Ref ref) {
  final helper = InternetConnectionHelper();
  ref.onDispose(helper.dispose);
  return helper;
}

@Riverpod(keepAlive: true)
class InternetConnectionNotifier extends _$InternetConnectionNotifier {
  @override
  bool build() {
    final helper = ref.watch(internetConnectionHelperProvider);
    helper.ensureListening();

    final subscription = helper.connectionStream.listen((connected) {
      state = connected;
    });
    ref.onDispose(subscription.cancel);

    unawaited(
      helper.hasConnection().then((connected) {
        if (ref.mounted) state = connected;
      }),
    );

    return true;
  }
}
