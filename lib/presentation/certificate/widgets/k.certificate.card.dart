import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../widgets/k.image.dart';

class KCertificateCard extends StatefulWidget {
  final CertificateModel certificate;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isHome;
  final bool fixedHeight;

  const KCertificateCard({
    super.key,
    required this.certificate,
    this.onTap,
    this.width = 500,
    this.height,
    required this.isHome,
    this.fixedHeight = true,
  });

  @override
  State<KCertificateCard> createState() => _KCertificateCardState();
}

class _KCertificateCardState extends State<KCertificateCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController = Get.find();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    final mediaWidth = MediaQuery.of(context).size.width;

    final double cardWidth = isMobile
        ? (mediaWidth * 0.45 > 340 ? mediaWidth * 0.45 : 340)
        : widget.width ?? 500;

    final double cardHeight = widget.height ?? 500;
    final double imageHeight = isMobile ? 280 : 320;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedScale(
        scale: isHover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.all(12),
            width: cardWidth,
            height: widget.fixedHeight ? cardHeight : null,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A1628).withAlpha((0.9 * 255).toInt()),
                  const Color(0xFF001529).withAlpha((0.85 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isHover
                    ? const Color(0xFF0A4A8E).withAlpha((0.6 * 255).toInt())
                    : const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.3 * 255).toInt()),
                  blurRadius: isHover ? 32 : 24,
                  offset: Offset(0, isHover ? 12 : 8),
                  spreadRadius: 0,
                ),
                if (isHover)
                  BoxShadow(
                    color: const Color(
                      0xFF0A4A8E,
                    ).withAlpha((0.2 * 255).toInt()),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                    spreadRadius: 2,
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: widget.fixedHeight
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    SizedBox(
                      height: imageHeight,
                      width: double.infinity,
                      child: KImage(url: widget.certificate.images[0]),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(
                                0xFF0A1628,
                              ).withAlpha((0.8 * 255).toInt()),
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.certificate.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: "Poppins",
                            height: 1.2,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),

                        Text(
                          widget.certificate.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withAlpha((0.85 * 255).toInt()),
                            fontFamily: "Poppins",
                            height: 1.5,
                          ),
                          maxLines: widget.fixedHeight ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        if (widget.isHome &&
                            widget.certificate.largeDescription.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Expanded(
                            child: Text(
                              widget.certificate.largeDescription,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withAlpha(
                                  (0.7 * 255).toInt(),
                                ),
                                fontFamily: "Poppins",
                                height: 1.5,
                              ),
                              maxLines: widget.fixedHeight ? 4 : null,
                              overflow: widget.fixedHeight
                                  ? TextOverflow.ellipsis
                                  : null,
                            ),
                          ),
                        ],

                        const Spacer(),

                        // Skills tags
                        if (widget.certificate.skills.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.certificate.skills
                                .take(3)
                                .map(
                                  (skill) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF0A4A8E,
                                          ).withAlpha((0.3 * 255).toInt()),
                                          const Color(
                                            0xFF001529,
                                          ).withAlpha((0.2 * 255).toInt()),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF0A4A8E,
                                        ).withAlpha((0.4 * 255).toInt()),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      skill,
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(
                                          (0.9 * 255).toInt(),
                                        ),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                        const SizedBox(height: 12),

                        // View details button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: isHover
                                    ? LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF0A4A8E,
                                          ).withAlpha((0.6 * 255).toInt()),
                                          const Color(
                                            0xFF001529,
                                          ).withAlpha((0.5 * 255).toInt()),
                                        ],
                                      )
                                    : LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF0A4A8E,
                                          ).withAlpha((0.4 * 255).toInt()),
                                          const Color(
                                            0xFF001529,
                                          ).withAlpha((0.3 * 255).toInt()),
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFF0A4A8E,
                                  ).withAlpha((0.5 * 255).toInt()),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View Details',
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(
                                        (0.95 * 255).toInt(),
                                      ),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                    color: Colors.white.withAlpha(
                                      (0.95 * 255).toInt(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
