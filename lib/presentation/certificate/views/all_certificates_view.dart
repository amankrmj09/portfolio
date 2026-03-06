import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';
import '../../../infrastructure/theme/colors.dart';
import '../../info.fetch.controller.dart';
import '../../../utils/all_items_view.dart';
import '../../../widgets/k.image.dart';
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
        title: "Certificates",
        isLoading: controller.isLoading.value,
        items: controller.certificates,
        titleColor: Colors.white,
        isMobile: isMobile,
        buildDialog: (certificate) => isMobile
            ? CertificateMobileView(
                certificate: certificate,
                onClose: () => Get.back(),
              )
            : CertificateView(
                certificate: certificate,
                onClose: () => Get.back(),
              ),
        buildCard: (certificate, onTap) => KCertificateCard(
          certificate: certificate,
          onTap: onTap,
          isHome: false,
        ),
        buildShimmerCard: () => KCertificateShimmerCard(isMobile: isMobile),
      ),
    );
  }
}

class KCertificateCard extends StatefulWidget {
  final CertificateModel certificate;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isHome;
  final bool fixedHeight;

  const KCertificateCard({
    super.key,
    required this.certificate,
    this.onTap,
    this.width = 500,
    this.height,
    required this.isHome,
    this.fixedHeight = true,
  });

  @override
  State<KCertificateCard> createState() => _KCertificateCardState();
}

class _KCertificateCardState extends State<KCertificateCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController = Get.find();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    final mediaWidth = MediaQuery.of(context).size.width;
    final double cardWidth = isMobile
        ? (mediaWidth * 0.45 > 340 ? mediaWidth * 0.45 : 340)
        : widget.width ?? 500;
    final double cardHeight = widget.height ?? 500;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedScale(
        scale: isHover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.all(12),
            width: cardWidth,
            height: widget.fixedHeight ? cardHeight : null,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  KColor.darkNavy.withValues(alpha: 0.9),
                  KColor.deepNavy.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isHover
                    ? KColor.accentBlue.withValues(alpha: 0.6)
                    : KColor.accentBlue.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: isHover ? 32 : 24,
                  offset: Offset(0, isHover ? 12 : 8),
                  spreadRadius: 0,
                ),
                if (isHover)
                  BoxShadow(
                    color: const Color(0xFF0A4A8E).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                    spreadRadius: 2,
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: widget.fixedHeight
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image section with hover overlay
                Expanded(
                  flex: 8,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: KImage(url: widget.certificate.images[0]),
                        ),
                      ),
                      // Hover overlay with skills
                      AnimatedOpacity(
                        opacity: isHover ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF001529,
                            ).withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                alignment: WrapAlignment.center,
                                children: widget.certificate.skills
                                    .map(
                                      (skill) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(
                                                0xFF0A4A8E,
                                              ).withValues(alpha: 0.3),
                                              const Color(
                                                0xFF001529,
                                              ).withValues(alpha: 0.2),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFF0A4A8E,
                                            ).withValues(alpha: 0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          skill,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 48),
                              Text(
                                widget.certificate.description,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 18,
                                  fontFamily: "Poppins",
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.justify,
                                maxLines: 3,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Issued by text
                        if (widget.certificate.issuingOrganization.isNotEmpty)
                          Text(
                            widget.certificate.issuingOrganization,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 8),
                        // Certificate title
                        Text(
                          widget.certificate.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.95),
                            fontFamily: "Poppins",
                            height: 1.3,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KCertificateShimmerCard extends StatelessWidget {
  final bool isMobile;

  const KCertificateShimmerCard({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: borderRadius,
      ),
      child: Column(
        children: [
          // Shimmering image placeholder
          Container(
            height: isMobile ? 200 : 150,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          // Shimmering text placeholders
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade800,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade800,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey.shade800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
