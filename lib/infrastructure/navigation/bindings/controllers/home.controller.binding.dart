import 'package:get/get.dart';
import '../../../../presentation/home/controllers/home.controller.dart';
import '../../../../presentation/projects/controllers/projects.controller.dart';
import '../../../../presentation/certificate/controllers/certificate.controller.dart';
import '../../../../presentation/about_me/controllers/about_me.controller.dart';
import '../../../../presentation/footer/controllers/footer.controller.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProjectsController>(() => ProjectsController());
    Get.lazyPut<CertificateController>(() => CertificateController());
    Get.lazyPut<AboutMeController>(() => AboutMeController());
    Get.lazyPut<FooterController>(() => FooterController());
  }
}
