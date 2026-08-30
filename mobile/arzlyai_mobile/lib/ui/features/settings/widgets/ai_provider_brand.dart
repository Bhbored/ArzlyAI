import 'package:arzlyai_mobile/core/constants/ai_providers.dart';
import 'package:arzlyai_mobile/ui/shared/widgets/brand_icon.dart';
import 'package:flutter/material.dart';

class AiProviderBrand extends StatelessWidget {
  const AiProviderBrand({
    required this.providerKey,
    this.size = 40,
    super.key,
  });

  final String providerKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BrandIcon.provider(providerKey, size: size);
  }

  static String displayName(String providerKey) =>
      aiProviderDisplayName(providerKey);
}
