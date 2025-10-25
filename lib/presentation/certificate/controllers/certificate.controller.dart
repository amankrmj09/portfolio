import 'package:get/get.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';

class CertificateController extends GetxController {
  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  // Direct getters - no local copies needed
  RxList<CertificateModel> get certificates => infoFetchController.certificates;

  RxBool get isLoading => infoFetchController.isCertificatesLoading;
}
