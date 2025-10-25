import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/projects/views/project_mobile_view.dart';
import '../../../domain/models/project_model/project.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../utils/all_items_view.dart';
import '../../../widgets/k.image.dart';
import 'project_view.dart';
import '../controllers/projects.controller.dart';

class AllProjectsView extends GetView<ProjectsController> {
  const AllProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController = Get.find();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;

    return Obx(
      () => AllItemsView(
        title: "Projects",
        isLoading: controller.isLoading.value,
        items: controller.projects,
        titleColor: Colors.white,
        isMobile: isMobile,
        buildDialog: (project) => isMobile
            ? WorkMobileView(
                project: project,
                onClose: () => Navigator.of(context).maybePop(),
              )
            : WorkView(
                project: project,
                onClose: () => Navigator.of(context).maybePop(),
              ),
        buildCard: (project, onTap) => KProjectCard(
          project: project,
          onTap: onTap,
          isHome: false,
          fixedHeight: true,
        ),
      ),
    );
  }
}

class KProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool fixedHeight;
  final bool isHome;

  const KProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.width = 500,
    this.fixedHeight = true,
    this.height,
    this.isHome = false,
  });

  @override
  State<KProjectCard> createState() => _KProjectCardState();
}

class _KProjectCardState extends State<KProjectCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController = Get.find();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    final mediaWidth = MediaQuery.of(context).size.width;
    final double cardWidth = isMobile
        ? (mediaWidth * 0.45 > 340 ? mediaWidth * 0.45 : 340)
        : widget.width ?? 500;
    final double cardHeight = widget.height ?? 650;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image section with hover overlay and type badge
                Expanded(
                  flex: 8,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: KImage(
                            url: widget.project.images.isNotEmpty
                                ? widget.project.images[0]
                                : '',
                          ),
                        ),
                      ),
                      // Type badge in top right (always visible)
                      if (widget.project.type.isNotEmpty)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
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
                              borderRadius: BorderRadius.circular(12),
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
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withAlpha(
                                  (0.95 * 255).toInt(),
                                ),
                                letterSpacing: 1.2,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ),
                      // Hover overlay with tech stack chips
                      AnimatedOpacity(
                        opacity: isHover ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF001529,
                            ).withAlpha((0.92 * 255).toInt()),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: widget.project.techStack.isNotEmpty
                                  ? Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      alignment: WrapAlignment.center,
                                      children: widget.project.techStack
                                          .map(
                                            (tech) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    const Color(
                                                      0xFF0A4A8E,
                                                    ).withAlpha(
                                                      (0.3 * 255).toInt(),
                                                    ),
                                                    const Color(
                                                      0xFF001529,
                                                    ).withAlpha(
                                                      (0.2 * 255).toInt(),
                                                    ),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(0xFF0A4A8E)
                                                      .withAlpha(
                                                        (0.5 * 255).toInt(),
                                                      ),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                tech,
                                                style: TextStyle(
                                                  color: Colors.white.withAlpha(
                                                    (0.9 * 255).toInt(),
                                                  ),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )
                                  : Text(
                                      'No tech stack available',
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(
                                          (0.6 * 255).toInt(),
                                        ),
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Project title
                        Text(
                          widget.project.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withAlpha((0.95 * 255).toInt()),
                            fontFamily: "Poppins",
                            height: 1.3,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Project description
                        if (widget.project.description.isNotEmpty)
                          Text(
                            widget.project.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withAlpha(
                                (0.6 * 255).toInt(),
                              ),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.justify,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
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
