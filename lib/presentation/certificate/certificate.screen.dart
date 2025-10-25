import 'dart:math';
import 'package:portfolio/presentation/info.fetch.controller.dart';
import 'package:portfolio/presentation/certificate/views/certificate_mobile_view.dart';
import 'package:portfolio/presentation/certificate/views/certificate_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/certificate/widgets/k.certificate.shimmer.card.dart';
import 'package:portfolio/presentation/certificate/widgets/k.home.certificates.scroll.dart';
import '../../utils/k.showGeneralDialog.dart';
import 'controllers/certificate.controller.dart';

class CertificateScreen extends GetView<CertificateController> {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController = Get.find();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;

    return Obx(() {
      if (controller.isLoading.value || controller.certificates.isEmpty) {
        // Show shimmer cards in a scrollable view to avoid overflow
        final shimmerCount = isMobile ? 3 : 6;
        final shimmerList = List.generate(
          shimmerCount,
          (_) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 4 : 8,
              horizontal: isMobile ? 0 : 8,
            ),
            child: KCertificateShimmerCard(isMobile: isMobile),
          ),
        );
        return SizedBox(
          height: isMobile
              ? MediaQuery.of(context).size.height * 0.85
              : max(MediaQuery.of(context).size.height - 100, 656),
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 12 : 24,
              horizontal: isMobile ? 8 : 32,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            children: shimmerList,
          ),
        );
      }

      return SizedBox(
        height: isMobile
            ? MediaQuery.of(context).size.height * 0.85
            : max(
                MediaQuery.of(context).size.height - 100,
                656,
              ), // ✅ CHANGED FROM 756 to 656
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
