import 'package:get/get.dart';

import '../../../../presentation/cli/controllers/cli.controller.dart';

class CliControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CliController>(
      () => CliController(),
    );
  }
}
