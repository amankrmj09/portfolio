import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/works/views/work_mobile_view.dart';
import 'package:portfolio/presentation/works/widgets/k.project.card.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../infrastructure/theme/colors.dart';
import '../../certificate/views/all_certificates_view.dart';
import 'work_view.dart';
import '../controllers/works.controller.dart';

class AllWorksView extends GetView<WorksController> {
  const AllWorksView({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    return Obx(
      () => AllItemsView(
        title: "ALL Projects",
        isLoading: controller.isLoading.value,
        items: controller.projects,
        titleColor: KColor.primarySecondColor,
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
          fixedHeight: false,
          // expandToContentHeight: true,
        ),
      ),
    );
  }
}
