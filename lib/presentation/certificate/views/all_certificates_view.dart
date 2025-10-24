import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/certificate/widgets/k.certificate.card.dart';
import 'package:portfolio/utils/axis.count.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../utils/k.showGeneralDialog.dart';
import 'certificate_mobile_view.dart';
import 'certificate_view.dart';
import '../controllers/certificate.controller.dart';

class AllCertificatesView extends GetView<CertificateController> {
  const AllCertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController = Get.find();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;

    return Obx(
      () => AllItemsView(
        title: "ALL Certificates",
        isLoading: controller.isLoading.value,
        items: controller.certificates,
        titleColor: Colors.white,
        isMobile: isMobile,
        buildDialog: (certificate) => isMobile
            ? CertificateMobileView(
                certificate: certificate,
                onClose: () => Navigator.of(context).maybePop(),
              )
            : CertificateView(
                certificate: certificate,
                onClose: () => Navigator.of(context).maybePop(),
              ),
        buildCard: (certificate, onTap) => KCertificateCard(
          certificate: certificate,
          onTap: onTap,
          isHome: false,
        ),
      ),
    );
  }
}

class AllItemsView<T> extends StatelessWidget {
  final String title;
  final bool isLoading;
  final List<T> items;
  final Color titleColor;
  final bool? isMobile;
  final Widget Function(T item) buildDialog;
  final Widget Function(T item, VoidCallback onTap) buildCard;

  const AllItemsView({
    super.key,
    required this.title,
    this.isMobile = false,
    required this.isLoading,
    required this.items,
    required this.titleColor,
    required this.buildDialog,
    required this.buildCard,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: isMobile! ? 24 : 36,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white.withAlpha((0.9 * 255).toInt()),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF0A4A8E),
                ),
              )
            : items.isEmpty
            ? Center(
                child: Text(
                  'No certificates found.',
                  style: TextStyle(
                    color: Colors.white.withAlpha((0.7 * 255).toInt()),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
            : ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                  },
                  overscroll: false,
                ),
                child: MasonryGridView.count(
                  controller: scrollController,
                  crossAxisCount: getCrossAxisCount(context),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return buildCard(
                      item,
                      () => showBlurredGeneralDialog(
                        context: context,
                        builder: (context) => buildDialog(item),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
