import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionHelper {
  InternetConnectionHelper({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  var _listening = false;

  Stream<bool> get connectionStream => _controller.stream;

  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  void ensureListening() {
    if (_listening) return;
    _listening = true;

    unawaited(
      hasConnection().then((connected) {
        if (!_controller.isClosed) _controller.add(connected);
      }),
    );

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (!_controller.isClosed) {
        _controller.add(_isConnected(results));
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
    _listening = false;
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
