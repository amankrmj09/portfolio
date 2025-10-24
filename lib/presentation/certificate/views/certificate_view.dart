import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/widgets/k.image.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';

class CertificateView extends StatelessWidget {
  final CertificateModel certificate;
  final VoidCallback? onClose;

  const CertificateView({super.key, required this.certificate, this.onClose});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight =
        (screenHeight > 776 ? screenHeight : 776) - 80;

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
                  const Color(0xFF0A1628).withAlpha((0.95 * 255).toInt()),
                  const Color(0xFF001529).withAlpha((0.9 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.5 * 255).toInt()),
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
                  color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
                ),
                Flexible(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32.0),
                      child: _buildContent(),
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
                color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
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
            color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
            color: Colors.white.withAlpha((0.85 * 255).toInt()),
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
            color: Colors.white.withAlpha((0.75 * 255).toInt()),
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
              color: Colors.white.withAlpha((0.9 * 255).toInt()),
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
                          const Color(
                            0xFF0A4A8E,
                          ).withAlpha((0.3 * 255).toInt()),
                          const Color(
                            0xFF001529,
                          ).withAlpha((0.2 * 255).toInt()),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(
                          0xFF0A4A8E,
                        ).withAlpha((0.4 * 255).toInt()),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        color: Colors.white.withAlpha((0.9 * 255).toInt()),
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
            const Color(0xFF0A4A8E).withAlpha((0.2 * 255).toInt()),
            const Color(0xFF001529).withAlpha((0.15 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: 24,
            color: const Color(0xFF0A4A8E).withAlpha((0.9 * 255).toInt()),
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
                    color: const Color(
                      0xFF0A4A8E,
                    ).withAlpha((0.9 * 255).toInt()),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(
                      0xFF0A4A8E,
                    ).withAlpha((0.9 * 255).toInt()),
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
            const Color(0xFF0A1628).withAlpha((0.6 * 255).toInt()),
            const Color(0xFF001529).withAlpha((0.5 * 255).toInt()),
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
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
                    const Color(0xFF8B0000).withAlpha((0.4 * 255).toInt()),
                    const Color(0xFF4B0000).withAlpha((0.3 * 255).toInt()),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF4444).withAlpha((0.3 * 255).toInt()),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, size: 24),
                onPressed: onClose ?? () => Navigator.of(context).maybePop(),
                tooltip: 'Close',
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                    const Color(0xFFFF4444).withAlpha((0.2 * 255).toInt()),
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
