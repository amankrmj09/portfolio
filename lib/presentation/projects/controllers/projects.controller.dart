import 'package:get/get.dart';
import 'package:portfolio/infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../domain/models/project_model/project.model.dart';

class ProjectsController extends GetxController {
  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  // Direct getters - no local copies needed
  RxList<ProjectModel> get projects => infoFetchController.projects;

  RxBool get isLoading => infoFetchController.isProjectsLoading;
}
