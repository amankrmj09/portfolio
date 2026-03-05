import 'dart:math';

import 'package:portfolio/presentation/projects/views/project_mobile_view.dart';
import 'package:portfolio/presentation/projects/views/project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/projects/widgets/k.home.projects.scroll.dart';
import 'package:portfolio/presentation/projects/widgets/k.project.shimmer.card.dart';

import '../info.fetch.controller.dart';
import '../../utils/k.showGeneralDialog.dart';
import 'controllers/projects.controller.dart';

class ProjectsScreen extends GetView<ProjectsController> {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    return Obx(() {
      if (controller.isLoading.value || controller.projects.isEmpty) {
        // Show shimmer cards in a scrollable view to avoid overflow
        final shimmerCount = isMobile ? 3 : 6;
        final shimmerList = List.generate(
          shimmerCount,
          (_) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 4 : 8,
              horizontal: isMobile ? 0 : 8,
            ),
            child: KProjectShimmerCard(isMobile: isMobile),
          ),
        );
        return SizedBox(
          height: isMobile
              ? MediaQuery.of(context).size.height * 0.85
              : max(MediaQuery.of(context).size.height - 100, 656),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 12 : 24,
              horizontal: isMobile ? 8 : 32,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            children: shimmerList,
          ),
        );
      }
      return SizedBox(
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.85
            : max(MediaQuery.of(context).size.height - 100, 656),
        child: KProjectsScrollList(
          items: controller.projects,
          onCardTap: (project, context) {
            showBlurredGeneralDialog(
              context: context,
              builder: (context) => isMobile
                  ? WorkMobileView(
                      project: project,
                      onClose: () => Navigator.of(context).maybePop(),
                    )
                  : WorkView(
                      project: project,
                      onClose: () => Navigator.of(context).maybePop(),
                    ),
            );
          },
        ),
      );
    });
  }
}
