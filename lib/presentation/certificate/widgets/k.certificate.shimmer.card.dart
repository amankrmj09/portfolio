import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KCertificateShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isMobile;

  const KCertificateShimmerCard({
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
            const Color(0xFF0A1628).withAlpha((0.9 * 255).toInt()),
            const Color(0xFF001529).withAlpha((0.85 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF0A4A8E).withAlpha((0.2 * 255).toInt()),
        highlightColor: const Color(0xFF001529).withAlpha((0.4 * 255).toInt()),
        child: Column(
          mainAxisSize: height != null ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: Colors.white.withAlpha((0.1 * 255).toInt()),
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
                          ).withAlpha((0.85 * 255).toInt()),
                        ],
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
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 10),
                    // Description placeholder
                    Container(
                      width: cardWidth * 0.9,
                      height: isMobile ? 14 * 3.5 : 14 * 2.8,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.15 * 255).toInt()),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    // Skills chips placeholders
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
                              color: Colors.white.withAlpha(
                                (0.1 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: const Color(
                                  0xFF0A4A8E,
                                ).withAlpha((0.3 * 255).toInt()),
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
                              color: Colors.white.withAlpha(
                                (0.1 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(
                                  0xFF0A4A8E,
                                ).withAlpha((0.3 * 255).toInt()),
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
