import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BrandIcon extends StatelessWidget {
  const BrandIcon._({
    required this.assetPath,
    required this.backgroundColor,
    this.tintColor,
    this.monochrome = true,
    this.size = 40,
    super.key,
  });

  factory BrandIcon.provider(String providerKey, {double size = 40, Key? key}) {
    return BrandIcon._(
      key: key,
      assetPath: _providerAsset(providerKey),
      backgroundColor: _providerBackground(providerKey),
      tintColor: _providerTint(providerKey),
      size: size,
    );
  }

  factory BrandIcon.linkedin({double size = 40, Key? key}) {
    return BrandIcon._(
      key: key,
      assetPath: 'assets/icons/connectors/linkedin.svg',
      backgroundColor: const Color(0xFF0A66C2),
      monochrome: false,
      size: size,
    );
  }

  final String assetPath;
  final Color backgroundColor;
  final Color? tintColor;
  final bool monochrome;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.52;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        assetPath,
        width: iconSize,
        height: iconSize,
        colorFilter: monochrome && tintColor != null
            ? ColorFilter.mode(tintColor!, BlendMode.srcIn)
            : null,
      ),
    );
  }

  static String _providerAsset(String providerKey) =>
      'assets/icons/providers/${switch (providerKey) {
        'gemini' => 'gemini',
        _ => providerKey,
      }}.svg';

  static Color _providerBackground(String providerKey) => switch (providerKey) {
    'openai' => const Color(0xFF0D0D0D),
    'anthropic' => const Color(0xFFCC785C),
    'gemini' => const Color(0xFF1A1A2E),
    'deepseek' => const Color(0xFF4D6BFE),
    _ => const Color(0xFF1A1A1A),
  };

  static Color _providerTint(String providerKey) => switch (providerKey) {
    'openai' => Colors.white,
    'anthropic' => Colors.white,
    'gemini' => const Color(0xFF8AB4F8),
    'deepseek' => Colors.white,
    _ => Colors.white,
  };
}
