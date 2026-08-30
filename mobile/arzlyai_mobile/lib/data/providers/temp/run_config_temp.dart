import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:arzlyai_mobile/domain/entities/preset/input_schema.dart';

part 'run_config_temp.freezed.dart';
part 'run_config_temp.g.dart';

@freezed
sealed class AgentOverrideDraft with _$AgentOverrideDraft {
  const factory AgentOverrideDraft({
    String? model,
    double? temperature,
  }) = _AgentOverrideDraft;
}

@freezed
sealed class RunConfigState with _$RunConfigState {
  const factory RunConfigState({
    @Default('') String topic,
    String? model,
    double? temperature,
    @Default(<String, String>{}) Map<String, String> inputs,
    @Default(<CandidateSeed>[]) List<CandidateSeed> candidateSeeds,
    @Default(<String, AgentOverrideDraft>{})
    Map<String, AgentOverrideDraft> agentOverrides,
  }) = _RunConfigState;
}

@Riverpod()
class RunConfigTemp extends _$RunConfigTemp {
  @override
  RunConfigState build() => const RunConfigState();

  void update(RunConfigState next) => state = next;

  void clear() => state = const RunConfigState();
}
