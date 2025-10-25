import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio/widgets/k.image.dart';
import '../../../domain/models/certificate_model/certificate.model.dart';

class CertificateMobileView extends StatelessWidget {
  final CertificateModel certificate;
  final VoidCallback? onClose;

  const CertificateMobileView({
    super.key,
    required this.certificate,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628), // ✅ Modern blackish-bluish
      extendBodyBehindAppBar: true,
      appBar: _buildModernAppBar(context),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 80,
            left: 16,
            right: 16,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Images
              _buildImageSection(),
              const SizedBox(height: 24),

              // 2. Certificate Name
              _buildTitle(),
              const SizedBox(height: 12),

              // 3. Organization Name
              _buildOrganization(),
              const SizedBox(height: 8),

              // 4. Date
              _buildDate(),
              const SizedBox(height: 20),

              // 5. Large Description
              _buildDescription(),
              const SizedBox(height: 24),

              // 6. Skills Chips
              if (certificate.skills.isNotEmpty) ...[
                _buildSkillsSection(),
                const SizedBox(height: 24),
              ],

              // 7. Link
              if (certificate.url.isNotEmpty) _buildLink(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _buildModernAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0A1628).withValues(alpha: 0.9),
              const Color(0xFF001529).withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF0A4A8E).withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              _buildBackButton(context),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  certificate.name,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 56), // Balance back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: onClose ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8B0000).withValues(alpha: 0.5),
              const Color(0xFF4B0000).withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFFF4444).withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white.withValues(alpha: 0.95),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF0A4A8E).withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: KImage(url: certificate.images[0]),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      certificate.name,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.95),
        fontFamily: 'Poppins',
        letterSpacing: 0.3,
        height: 1.3,
      ),
    );
  }

  Widget _buildOrganization() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A4A8E).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.business_rounded,
            color: Colors.white.withValues(alpha: 0.9),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            certificate.issuingOrganization,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.85),
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDate() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A4A8E).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.calendar_today_rounded,
            color: Colors.white.withValues(alpha: 0.9),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          certificate.issueDate,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.75),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      certificate.largeDescription,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white.withValues(alpha: 0.8),
        fontFamily: 'Poppins',
        height: 1.6,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.95),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: certificate.skills
              .map(
                (skill) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLink() {
    return GestureDetector(
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0A4A8E).withValues(alpha: 0.3),
              const Color(0xFF001529).withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF0A4A8E).withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A4A8E).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.link_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'View Certificate',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white.withValues(alpha: 0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
