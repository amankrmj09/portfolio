import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/resume_model/certificate_model.dart';
import '../controllers/resume.controller.dart';
import '../widgets/shimmer_cards.dart';

class CertificatesView extends StatelessWidget {
  const CertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final ResumeController resumeController = Get.find();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final certificates =
            resumeController.resumeData.value?.certificates ?? [];
        if (certificates.isEmpty) {
          return const ShimmerList();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: certificates
                .map((certificate) => _CertificateCard(certificate))
                .toList(),
          ),
        );
      }),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final CertificateModel certificate;

  const _CertificateCard(this.certificate);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF001529).withAlpha((0.7 * 255).toInt()),
            const Color(0xFF000A1F).withAlpha((0.6 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withAlpha((0.4 * 255).toInt()),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: const Color(0xFF0A4A8E).withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withAlpha((0.2 * 255).toInt()),
                      Colors.white.withAlpha((0.1 * 255).toInt()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.card_membership_rounded,
                  color: Colors.white.withAlpha((0.9 * 255).toInt()),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  certificate.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.15 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              certificate.issuer,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: Colors.white.withAlpha((0.7 * 255).toInt()),
              ),
              const SizedBox(width: 8),
              Text(
                certificate.type,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withAlpha((0.85 * 255).toInt()),
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
