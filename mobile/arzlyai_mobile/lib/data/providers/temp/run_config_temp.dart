import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'run_config_temp.freezed.dart';
part 'run_config_temp.g.dart';

@freezed
sealed class RunConfigState with _$RunConfigState {
  const factory RunConfigState({
    @Default('') String topic,
    String? model,
    double? temperature,
  }) = _RunConfigState;
}

@Riverpod()
class RunConfigTemp extends _$RunConfigTemp {
  @override
  RunConfigState build() => const RunConfigState();

  void update(RunConfigState next) => state = next;

  void clear() => state = const RunConfigState();
}
