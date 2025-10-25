import 'package:get/get.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class AdminController extends GetxController {
  final count = 0.obs;

  // Add meshGradientController
  late final AnimatedMeshGradientController meshGradientController;

  @override
  void onInit() {
    super.onInit();
    meshGradientController = AnimatedMeshGradientController()..start();
  }

  void increment() => count.value++;
}
