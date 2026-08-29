// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_draft_temp.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReviewDraftTemp)
final reviewDraftTempProvider = ReviewDraftTempProvider._();

final class ReviewDraftTempProvider
    extends $NotifierProvider<ReviewDraftTemp, String> {
  ReviewDraftTempProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewDraftTempProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewDraftTempHash();

  @$internal
  @override
  ReviewDraftTemp create() => ReviewDraftTemp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$reviewDraftTempHash() => r'44634e5c5caaf4fa51de95ce2a3eb57d9140d9b6';

abstract class _$ReviewDraftTemp extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
