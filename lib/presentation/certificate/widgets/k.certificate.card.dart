import 'dart:async';

import 'package:flutter/material.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';
import '../../../infrastructure/theme/colors.dart';
import '../../../widgets/k.image.dart';

class KCertificateCard extends StatefulWidget {
  final CertificateModel certificate;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isMobile;

  const KCertificateCard({
    super.key,
    required this.certificate,
    this.onTap,
    this.width,
    this.height,
    this.isMobile = false,
  });

  @override
  State<KCertificateCard> createState() => _KCertificateCardState();
}

class _KCertificateCardState extends State<KCertificateCard> {
  bool isHovered = false;
  bool showAnimation = false;
  Timer? _hoverTimer;

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _onEnter() {
    if (widget.isMobile) return;
    setState(() => isHovered = true);

    // Start timer for animation
    _hoverTimer = Timer(const Duration(seconds: 1), () {
      if (mounted && isHovered) {
        setState(() => showAnimation = true);
      }
    });
  }

  void _onExit() {
    if (widget.isMobile) return;
    _hoverTimer?.cancel();
    setState(() {
      isHovered = false;
      showAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;

    // ✅ Card width: 340-500px range, responsive
    final double cardWidth = widget.isMobile
        ? mediaWidth * 0.9
        : (widget.width ?? 450).clamp(340.0, 500.0);

    // ✅ Image height based on device
    final double imageHeight = widget.isMobile ? 280 : 340;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: widget.isMobile ? null : (_) => _onEnter(),
      onExit: widget.isMobile ? null : (_) => _onExit(),
      child: AnimatedScale(
        scale: (widget.isMobile || !showAnimation) ? 1.0 : 1.02,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.all(widget.isMobile ? 6 : 12),
            width: cardWidth,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  KColor.darkNavy.withValues(alpha: 0.9),
                  KColor.deepNavy.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(widget.isMobile ? 16 : 20),
              border: Border.all(
                color: showAnimation
                    ? KColor.accentBlue.withValues(alpha: 0.6)
                    : KColor.accentBlue.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: showAnimation ? 28 : 20,
                  offset: Offset(0, showAnimation ? 10 : 6),
                ),
                if (showAnimation && !widget.isMobile)
                  BoxShadow(
                    color: const Color(
                      0xFF0A4A8E,
                    ).withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: widget.height != null
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  alignment: AlignmentGeometry.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: imageHeight,
                        child: KImage(url: widget.certificate.images[0]),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: widget.isMobile ? 50 : 80,
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
                  ],
                ),

                // Content section
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(widget.isMobile ? 14.0 : 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.certificate.name,
                          style: TextStyle(
                            fontSize: widget.isMobile ? 16 : 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: "Poppins",
                            height: 1.2,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: widget.isMobile ? 8 : 10),

                        // Description
                        Text(
                          widget.certificate.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontFamily: "Poppins",
                            height: 1.4,
                          ),
                          maxLines: widget.isMobile ? 4 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        // Skills chips - ✅ Visible on all screens
                        if (widget.certificate.skills.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: widget.isMobile ? 4 : 12,
                            ),
                            child: Wrap(
                              spacing: widget.isMobile ? 6 : 7,
                              runSpacing: widget.isMobile ? 6 : 7,
                              alignment: WrapAlignment.spaceBetween,
                              children: widget.certificate.skills
                                  .take(3)
                                  .map(
                                    (skill) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: widget.isMobile ? 8 : 10,
                                        vertical: widget.isMobile ? 4 : 5,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(
                                              0xFF0A4A8E,
                                            ).withValues(alpha: 0.25),
                                            const Color(
                                              0xFF001529,
                                            ).withValues(alpha: 0.15),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF0A4A8E,
                                          ).withValues(alpha: 0.35),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        skill,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                        // ✅ Button only on desktop
                        if (!widget.isMobile) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  gradient: showAnimation
                                      ? LinearGradient(
                                          colors: [
                                            const Color(
                                              0xFF0A4A8E,
                                            ).withValues(alpha: 0.6),
                                            const Color(
                                              0xFF001529,
                                            ).withValues(alpha: 0.5),
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            const Color(
                                              0xFF0A4A8E,
                                            ).withValues(alpha: 0.4),
                                            const Color(
                                              0xFF001529,
                                            ).withValues(alpha: 0.3),
                                          ],
                                        ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF0A4A8E,
                                    ).withValues(alpha: 0.45),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.95),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
                                      color: Colors.white.withValues(alpha: 0.95),
                                    ),
                                  ],
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
        ),
      ),
    );
  }
}
