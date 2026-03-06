import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/models/project_model/project.model.dart';
import '../../../infrastructure/theme/colors.dart';
import '../../../widgets/k.infinite.scroll.image.dart';

class WorkView extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback? onClose;

  const WorkView({super.key, required this.project, this.onClose});

  @override
  State<WorkView> createState() => _WorkViewState();
}

class _WorkViewState extends State<WorkView> {
  @override
  Widget build(BuildContext context) {
    final isMobile = widget.project.type == 'mobile';
    final screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight =
        (screenHeight > 776 ? screenHeight : 776) - 80;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: containerHeight,
            constraints: const BoxConstraints(maxWidth: 1400, minHeight: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  KColor.darkNavy.withValues(alpha: 0.95),
                  KColor.deepNavy.withValues(alpha: 0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: KColor.accentBlue.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildAppBar(context),
                Divider(
                  height: 1,
                  color: KColor.accentBlue.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: isMobile ? _buildMobileLayout() : _buildWebLayout(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: SingleChildScrollView(child: _buildContent()),
            ),
          ),
        ),
        Container(width: 1, color: KColor.accentBlue.withValues(alpha: 0.2)),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: double.infinity,
            child: KInfiniteScrollImage(
              images: widget.project.images,
              height: 600,
              imageWidth: 700,
              direction: "vertical",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWebLayout() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            const SizedBox(height: 32),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.project.name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
            fontFamily: 'Poppins',
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        // // Project type badge
        // if (widget.project.type.isNotEmpty)
        //   Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           KColor.accentBlue.withValues(alpha: 0.4),
        //           KColor.deepNavy.withValues(alpha: 0.3),
        //         ],
        //       ),
        //       borderRadius: BorderRadius.circular(12),
        //       border: Border.all(
        //         color: KColor.accentBlue.withValues(alpha: 0.5),
        //         width: 1,
        //       ),
        //     ),
        //     child: Text(
        //       widget.project.type.toUpperCase(),
        //       style: TextStyle(
        //         fontSize: 13,
        //         fontWeight: FontWeight.w700,
        //         color: Colors.white.withValues(alpha: 0.95),
        //         letterSpacing: 1.5,
        //         fontFamily: "Poppins",
        //       ),
        //     ),
        //   ),
        // const SizedBox(height: 20),

        // Tech stack
        if (widget.project.techStack.isNotEmpty) ...[
          Text(
            'Technologies',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.project.techStack
                .map(
                  (tech) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0A4A8E).withValues(alpha: 0.3),
                          const Color(0xFF001529).withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0A4A8E).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tech,
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
          const SizedBox(height: 24),
        ],

        // Large description
        Text(
          widget.project.largeDescription,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.85),
            fontFamily: "Poppins",
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),

        // Project URL
        if (widget.project.url.isNotEmpty) _buildLinkRow(),
      ],
    );
  }

  Widget _buildLinkRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KColor.accentBlue.withValues(alpha: 0.2),
            KColor.deepNavy.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: KColor.accentBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: 24,
            color: KColor.accentBlue.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  final url = Uri.parse(widget.project.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                      webOnlyWindowName: '_blank',
                    );
                  }
                },
                child: Text(
                  widget.project.url,
                  style: TextStyle(
                    color: const Color(0xFF0A4A8E).withValues(alpha: 0.9),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(
                      0xFF0A4A8E,
                    ).withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KColor.darkNavy.withValues(alpha: 0.6),
            KColor.deepNavy.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.project.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.95),
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    KColor.darkRed.withValues(alpha: 0.4),
                    KColor.darkerRed.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: KColor.alertRed.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 24),
                onPressed:
                    widget.onClose ?? () => Navigator.of(context).maybePop(),
                tooltip: 'Close',
                color: Colors.white.withValues(alpha: 0.95),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                    KColor.alertRed.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 450),
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: KColor.accentBlue.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: KInfiniteScrollImage(images: widget.project.images, height: 380),
      ),
    );
  }
}
