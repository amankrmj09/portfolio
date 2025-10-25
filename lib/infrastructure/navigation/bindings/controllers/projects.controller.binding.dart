import 'package:get/get.dart';

import '../../../../presentation/projects/controllers/projects.controller.dart';

class ProjectsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectsController>(() => ProjectsController());
  }
}
