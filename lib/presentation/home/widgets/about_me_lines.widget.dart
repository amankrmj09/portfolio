import 'package:flutter/material.dart';
import '../../../configs/constant_strings.dart';

/// About Me Lines Widget - Dynamic font size based on width
class AboutMeLines extends StatelessWidget {
  final double width;
  final double height;

  const AboutMeLines({super.key, this.width = 500, this.height = 150});

  double _getResponsiveFontSize(double width) {
    const double minWidth = 200.0;
    const double maxWidth = 600.0;
    const double minFontSize = 16.0;
    const double maxFontSize = 24.0;

    final clampedWidth = width.clamp(minWidth, maxWidth);
    final t = (clampedWidth - minWidth) / (maxWidth - minWidth);
    return minFontSize + (maxFontSize - minFontSize) * t;
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = _getResponsiveFontSize(width);

    return SizedBox(
      height: height,
      width: width,
      child: Text.rich(
        TextSpan(
          text: "$kHomeDisplayLineAboutMe01\n",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontFamily: "ShantellSans",
          ),
          children: [
            TextSpan(
              text: "$kHomeDisplayLineAboutMe02\n",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: "$kHomeDisplayLineAboutMe03\n",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
