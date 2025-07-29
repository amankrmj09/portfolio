import 'dart:math';

import 'package:portfolio/infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import 'package:portfolio/presentation/certificate/views/certificate_mobile_view.dart';
import 'package:portfolio/presentation/certificate/views/certificate_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:portfolio/presentation/certificate/widgets/k.home.certificates.scroll.dart';

import '../../utils/k.showGeneralDialog.dart';
import 'controllers/certificate.controller.dart';

class CertificateScreen extends GetView<CertificateController> {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SizedBox(
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.85
            : max(MediaQuery.of(context).size.height - 100, 756),
        child: KCertificateScrollList(
          items: controller.certificates,
          onCardTap: (cert, context) {
            showBlurredGeneralDialog(
              context: context,
              builder: (context) => isMobile
                  ? CertificateMobileView(
                      certificate: cert,
                      onClose: () => Navigator.of(context).maybePop(),
                    )
                  : CertificateView(
                      certificate: cert,
                      onClose: () => Navigator.of(context).maybePop(),
                    ),
            );
          },
        ),
      );
    });
  }
}
