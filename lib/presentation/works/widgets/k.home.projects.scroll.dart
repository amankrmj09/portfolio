import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/works/widgets/k.project.card.dart';

import '../../../domain/models/project_model/project.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';

import '../../../infrastructure/navigation/routes.dart';

class KProjectsScrollList extends StatelessWidget {
  final List<ProjectModel> items;
  final void Function(ProjectModel project, BuildContext context) onCardTap;

  const KProjectsScrollList({
    super.key,
    required this.items,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    if (items.isEmpty) {
      Future.microtask(() => Get.find<InfoFetchController>().fetchProjects());
      return const Center(
        child: Text(
          'Loading projects... Please wait.',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: (items.length < 4 ? items.length : 4) + (isMobile ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final int maxItems = items.length < 4 ? items.length : 4;
          if (index < maxItems) {
            final item = items[index];
            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: KProjectCard(
                    isHome: false,
                    project: item,
                    onTap: () => onCardTap(item, context),
                    height: constraints.maxHeight - 60,
                  ),
                );
              },
            );
          } else if (isMobile && index == maxItems) {
            return Container(
              width: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 1.5),
                gradient: LinearGradient(
                  colors: [
                    Color.lerp(Colors.transparent, Colors.white, 0.15)!,
                    Color.lerp(Colors.transparent, Colors.white, 0.25)!,
                    Color.lerp(Colors.transparent, Colors.white, 0.35)!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.mirror,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Get.toNamed(Routes.ALL_PROJECTS),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF43C6AC), Color(0xFF191654)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (0.15 * 255).toInt(),
                              ),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_awesome_mosaic_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Browse All Projects",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ShantellSans',
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
