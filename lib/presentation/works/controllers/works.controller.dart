import 'package:get/get.dart';
import 'package:portfolio/infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../domain/models/project_model/project.model.dart';

class WorksController extends GetxController {
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxBool isLoading = false.obs;

  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  @override
  void onInit() {
    super.onInit();
    _initializeProjects();
  }

  void _initializeProjects() {
    isLoading.value = infoFetchController.isProjectsLoading.value;
    projects.value = infoFetchController.projects;

    // Listen to changes
    ever(infoFetchController.isProjectsLoading, (val) {
      isLoading.value = val;
    });

    ever(infoFetchController.projects, (val) {
      projects.value = val;
    });
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
