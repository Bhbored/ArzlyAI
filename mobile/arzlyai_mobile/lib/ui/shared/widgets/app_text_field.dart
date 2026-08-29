import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:arzlyai_mobile/data/providers/temp/review_draft_temp.dart';
import 'package:arzlyai_mobile/data/providers/temp/run_config_temp.dart';

enum AppTextFieldKind { topic, reviewDraft }

class AppTextField extends ConsumerWidget {
  const AppTextField._({
    required this.kind,
    this.placeholder,
    this.maxLines = 1,
    super.key,
  });

  factory AppTextField.topic({Key? key}) => AppTextField._(
    kind: AppTextFieldKind.topic,
    placeholder: 'Topic',
    maxLines: 3,
    key: key,
  );

  factory AppTextField.reviewDraft({Key? key}) => AppTextField._(
    kind: AppTextFieldKind.reviewDraft,
    placeholder: 'e.g. Use a stronger opening and shorten the post',
    maxLines: 8,
    key: key,
  );

  final AppTextFieldKind kind;
  final String? placeholder;
  final int maxLines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = switch (kind) {
      AppTextFieldKind.topic => ref.watch(runConfigTempProvider).topic,
      AppTextFieldKind.reviewDraft => ref.watch(reviewDraftTempProvider),
    };

    return ShadInput(
      initialValue: value,
      placeholder: placeholder == null ? null : Text(placeholder!),
      maxLines: maxLines,
      onChanged: (next) {
        switch (kind) {
          case AppTextFieldKind.topic:
            final current = ref.read(runConfigTempProvider);
            ref
                .read(runConfigTempProvider.notifier)
                .update(current.copyWith(topic: next));
          case AppTextFieldKind.reviewDraft:
            ref.read(reviewDraftTempProvider.notifier).update(next);
        }
      },
    );
  }
}
