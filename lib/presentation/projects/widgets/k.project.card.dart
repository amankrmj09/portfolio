import 'package:flutter/material.dart';
import '../../../domain/models/project_model/project.model.dart';
import '../../../widgets/k.image.dart';

class KProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isMobile;

  const KProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.width,
    this.height,
    this.isMobile = false,
  });

  @override
  State<KProjectCard> createState() => _KProjectCardState();
}

class _KProjectCardState extends State<KProjectCard> {
  bool isHovered = false;

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
      onEnter: widget.isMobile ? null : (_) => setState(() => isHovered = true),
      onExit: widget.isMobile ? null : (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: (widget.isMobile || !isHovered) ? 1.0 : 1.02,
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
                  const Color(0xFF0A1628).withAlpha((0.9 * 255).toInt()),
                  const Color(0xFF001529).withAlpha((0.85 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(widget.isMobile ? 16 : 20),
              border: Border.all(
                color: isHovered
                    ? const Color(0xFF0A4A8E).withAlpha((0.6 * 255).toInt())
                    : const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.3 * 255).toInt()),
                  blurRadius: isHovered ? 28 : 20,
                  offset: Offset(0, isHovered ? 10 : 6),
                ),
                if (isHovered && !widget.isMobile)
                  BoxShadow(
                    color: const Color(
                      0xFF0A4A8E,
                    ).withAlpha((0.15 * 255).toInt()),
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
                        child: KImage(url: widget.project.images[0]),
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
                              ).withAlpha((0.85 * 255).toInt()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Type badge
                    if (widget.project.type.isNotEmpty)
                      Positioned(
                        top: widget.isMobile ? 10 : 12,
                        right: widget.isMobile ? 10 : 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: widget.isMobile ? 8 : 10,
                            vertical: widget.isMobile ? 4 : 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(
                                  0xFF0A4A8E,
                                ).withAlpha((0.9 * 255).toInt()),
                                const Color(
                                  0xFF001529,
                                ).withAlpha((0.8 * 255).toInt()),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              widget.isMobile ? 8 : 10,
                            ),
                            border: Border.all(
                              color: Colors.white.withAlpha(
                                (0.2 * 255).toInt(),
                              ),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            widget.project.type.toUpperCase(),
                            style: TextStyle(
                              fontSize: widget.isMobile ? 9 : 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withAlpha(
                                (0.95 * 255).toInt(),
                              ),
                              letterSpacing: 1.1,
                              fontFamily: "Poppins",
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
                          widget.project.name,
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
                          widget.project.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withAlpha((0.8 * 255).toInt()),
                            fontFamily: "Poppins",
                            height: 1.4,
                          ),
                          maxLines: widget.isMobile ? 4 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),

                        // Tech stack chips - ✅ Visible on all screens
                        if (widget.project.techStack.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: widget.isMobile ? 4 : 12,
                            ),
                            child: Wrap(
                              spacing: widget.isMobile ? 6 : 7,
                              runSpacing: widget.isMobile ? 6 : 7,
                              alignment: WrapAlignment.spaceBetween,
                              children: widget.project.techStack
                                  .take(3)
                                  .map(
                                    (tech) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: widget.isMobile ? 8 : 10,
                                        vertical: widget.isMobile ? 4 : 5,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(
                                              0xFF0A4A8E,
                                            ).withAlpha((0.25 * 255).toInt()),
                                            const Color(
                                              0xFF001529,
                                            ).withAlpha((0.15 * 255).toInt()),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF0A4A8E,
                                          ).withAlpha((0.35 * 255).toInt()),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        tech,
                                        style: TextStyle(
                                          color: Colors.white.withAlpha(
                                            (0.9 * 255).toInt(),
                                          ),
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
                                  gradient: isHovered
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
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF0A4A8E,
                                    ).withAlpha((0.45 * 255).toInt()),
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
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
