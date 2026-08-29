import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_draft_temp.g.dart';

@Riverpod()
class ReviewDraftTemp extends _$ReviewDraftTemp {
  @override
  String build() => '';

  void update(String next) => state = next;

  void clear() => state = '';
}
