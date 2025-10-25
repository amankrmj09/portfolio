import 'dart:math';

import 'package:portfolio/presentation/projects/views/project_mobile_view.dart';
import 'package:portfolio/presentation/projects/views/project_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/projects/widgets/k.home.projects.scroll.dart';

import '../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
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
        return const Center(child: CircularProgressIndicator());
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
