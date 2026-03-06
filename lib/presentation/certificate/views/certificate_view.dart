import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio/utils/k.smoothscrollweb.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/widgets/k.image.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';
import '../../../infrastructure/theme/colors.dart';

class CertificateView extends StatelessWidget {
  final CertificateModel certificate;
  final VoidCallback? onClose;

  const CertificateView({super.key, required this.certificate, this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight =
        (screenHeight > 776 ? screenHeight : 776) - 80;
    final ScrollController scrollController = ScrollController();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 1200,
              maxHeight: containerHeight,
              minHeight: 600,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  KColor.darkNavy.withValues(alpha: 0.95),
                  KColor.deepNavy.withValues(alpha: 0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: KColor.accentBlue.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAppBar(context),
                Divider(
                  height: 1,
                  color: KColor.accentBlue.withValues(alpha: 0.3),
                ),
                Flexible(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: KSmoothScrollWeb(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32.0),
                        child: _buildContent(),
                      ),
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

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Certificate image
        Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 450),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: KColor.accentBlue.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: KImage(url: certificate.images[0]),
          ),
        ),
        const SizedBox(height: 32),

        // Certificate name
        Text(
          certificate.name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
            fontFamily: 'Poppins',
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),

        // Description
        Text(
          certificate.description,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.85),
            fontFamily: 'Poppins',
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),

        // Large description
        Text(
          certificate.largeDescription,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.75),
            fontFamily: 'Poppins',
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),

        // Skills section
        if (certificate.skills.isNotEmpty) ...[
          Text(
            'Skills',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: certificate.skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0A4A8E).withValues(alpha: 0.3),
                          const Color(0xFF001529).withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0A4A8E).withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Certificate URL
        if (certificate.url.isNotEmpty) _buildLinkRow(),
      ],
    );
  }

  Widget _buildLinkRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KColor.accentBlue.withValues(alpha: 0.2),
            KColor.deepNavy.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: KColor.accentBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: 24,
            color: KColor.accentBlue.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  final url = Uri.parse(certificate.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                      webOnlyWindowName: '_blank',
                    );
                  }
                },
                child: Text(
                  certificate.url,
                  style: TextStyle(
                    color: const Color(0xFF0A4A8E).withValues(alpha: 0.9),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(
                      0xFF0A4A8E,
                    ).withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KColor.darkNavy.withValues(alpha: 0.6),
            KColor.deepNavy.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              certificate.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white.withValues(alpha: 0.95),
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    KColor.darkRed.withValues(alpha: 0.4),
                    KColor.darkerRed.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: KColor.alertRed.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 24),
                onPressed: onClose ?? () => Navigator.of(context).maybePop(),
                tooltip: 'Close',
                color: Colors.white.withValues(alpha: 0.95),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                    KColor.alertRed.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
