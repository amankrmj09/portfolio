import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/models/project_model/project.model.dart';
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
                  const Color(0xFF0A1628).withAlpha((0.95 * 255).toInt()),
                  const Color(0xFF001529).withAlpha((0.9 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.5 * 255).toInt()),
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
                  color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
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
        Container(
          width: 1,
          color: const Color(0xFF0A4A8E).withAlpha((0.2 * 255).toInt()),
        ),
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
            color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
        //           const Color(0xFF0A4A8E).withAlpha((0.4 * 255).toInt()),
        //           const Color(0xFF001529).withAlpha((0.3 * 255).toInt()),
        //         ],
        //       ),
        //       borderRadius: BorderRadius.circular(12),
        //       border: Border.all(
        //         color: const Color(0xFF0A4A8E).withAlpha((0.5 * 255).toInt()),
        //         width: 1,
        //       ),
        //     ),
        //     child: Text(
        //       widget.project.type.toUpperCase(),
        //       style: TextStyle(
        //         fontSize: 13,
        //         fontWeight: FontWeight.w700,
        //         color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
              color: Colors.white.withAlpha((0.9 * 255).toInt()),
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
                          const Color(
                            0xFF0A4A8E,
                          ).withAlpha((0.3 * 255).toInt()),
                          const Color(
                            0xFF001529,
                          ).withAlpha((0.2 * 255).toInt()),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(
                          0xFF0A4A8E,
                        ).withAlpha((0.4 * 255).toInt()),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tech,
                      style: TextStyle(
                        color: Colors.white.withAlpha((0.9 * 255).toInt()),
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
            color: Colors.white.withAlpha((0.85 * 255).toInt()),
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
            const Color(0xFF0A4A8E).withAlpha((0.2 * 255).toInt()),
            const Color(0xFF001529).withAlpha((0.15 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: 24,
            color: const Color(0xFF0A4A8E).withAlpha((0.9 * 255).toInt()),
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
                    color: const Color(
                      0xFF0A4A8E,
                    ).withAlpha((0.9 * 255).toInt()),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(
                      0xFF0A4A8E,
                    ).withAlpha((0.9 * 255).toInt()),
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
            const Color(0xFF0A1628).withAlpha((0.6 * 255).toInt()),
            const Color(0xFF001529).withAlpha((0.5 * 255).toInt()),
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
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
                    const Color(0xFF8B0000).withAlpha((0.4 * 255).toInt()),
                    const Color(0xFF4B0000).withAlpha((0.3 * 255).toInt()),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF4444).withAlpha((0.3 * 255).toInt()),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 24),
                onPressed:
                    widget.onClose ?? () => Navigator.of(context).maybePop(),
                tooltip: 'Close',
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                    const Color(0xFFFF4444).withAlpha((0.2 * 255).toInt()),
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
            color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: KInfiniteScrollImage(images: widget.project.images, height: 380),
      ),
    );
  }
}
