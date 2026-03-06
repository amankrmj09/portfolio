import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'animated.rotate.icon.dart';

/// Animated Social Icon Widget
class AnimatedSocialIcon extends StatelessWidget {
  final String outline;
  final String color;
  final String label;
  final String url;
  final Color iconColor;

  const AnimatedSocialIcon({
    super.key,
    required this.outline,
    required this.color,
    required this.label,
    required this.url,
    this.iconColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotateIcon(
      firstIcon: SvgPicture.asset(
        outline,
        width: 32,
        height: 32,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
      secondIcon: SvgPicture.asset(color, width: 32, height: 32),
      label: label,
      url: url,
    );
  }
}
