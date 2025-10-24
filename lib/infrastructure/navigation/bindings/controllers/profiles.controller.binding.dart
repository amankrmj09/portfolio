import 'package:get/get.dart';

import '../../../../presentation/profiles/controllers/profiles.controller.dart';

class ProfilesControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilesController>(
      () => ProfilesController(),
    );
  }
}
