import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../infrastructure/theme/colors.dart';

class KProjectShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isMobile;

  const KProjectShimmerCard({
    super.key,
    this.width,
    this.height,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final double cardWidth = isMobile
        ? mediaWidth * 0.9
        : (width ?? 450).clamp(340.0, 500.0);
    final double imageHeight = isMobile ? 280 : 340;

    return Container(
      margin: EdgeInsets.all(isMobile ? 6 : 12),
      width: cardWidth,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            KColor.darkNavy.withValues(alpha: 0.9),
            KColor.deepNavy.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: KColor.accentBlue.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: KColor.accentBlue.withValues(alpha: 0.2),
        highlightColor: KColor.deepNavy.withValues(alpha: 0.4),
        child: Column(
          mainAxisSize: height != null ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                // Gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: isMobile ? 50 : 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(
                            0xFF0A1628,
                          ).withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),
                // Type badge placeholder
                Positioned(
                  top: isMobile ? 10 : 12,
                  right: isMobile ? 10 : 12,
                  child: Container(
                    width: isMobile ? 48 : 56,
                    height: isMobile ? 18 : 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                      border: Border.all(
                        color: const Color(
                          0xFF0A4A8E,
                        ).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 14.0 : 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      width: cardWidth * 0.7,
                      height: isMobile ? 18 : 22,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 10),
                    // Description placeholder
                    Container(
                      width: cardWidth * 0.9,
                      height: isMobile ? 14 * 3.5 : 14 * 2.8,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    // Tech stack chips placeholders
                    Padding(
                      padding: EdgeInsets.only(bottom: isMobile ? 4 : 12),
                      child: Wrap(
                        spacing: isMobile ? 6 : 7,
                        runSpacing: isMobile ? 6 : 7,
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 60,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: const Color(
                                  0xFF0A4A8E,
                                ).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Button placeholder (desktop only)
                    if (!isMobile) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 110,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(
                                  0xFF0A4A8E,
                                ).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
