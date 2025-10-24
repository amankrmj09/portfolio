import 'package:get/get.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';

class CertificateController extends GetxController {
  final RxList<CertificateModel> certificates = <CertificateModel>[].obs;
  final RxBool isLoading = false.obs;

  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  @override
  void onInit() {
    super.onInit();
    _initializeCertificates();
  }

  void _initializeCertificates() {
    isLoading.value = infoFetchController.isCertificatesLoading.value;
    certificates.value = infoFetchController.certificates;

    // Listen to changes
    ever(infoFetchController.isCertificatesLoading, (val) {
      isLoading.value = val;
    });

    ever(infoFetchController.certificates, (val) {
      certificates.value = val;
    });
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
