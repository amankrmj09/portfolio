import 'package:get/get.dart';

import '../../../../presentation/resume/controllers/resume.controller.dart';

class ResumeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResumeController>(
      () => ResumeController(),
    );
  }
}
