import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/resume_model/education_model.dart';
import '../controllers/resume.controller.dart';
import '../widgets/shimmer_cards.dart';

class EducationView extends StatelessWidget {
  const EducationView({super.key});

  @override
  Widget build(BuildContext context) {
    final ResumeController resumeController = Get.find();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final educationList =
            resumeController.resumeData.value?.education ?? [];
        if (educationList.isEmpty) {
          return const ShimmerList();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: educationList
                .map((education) => _EducationCard(education))
                .toList(),
          ),
        );
      }),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final EducationModel education;

  const _EducationCard(this.education);

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
            const Color(0xFF001529).withOpacity(0.7),
            const Color(0xFF000A1F).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: const Color(0xFF0A4A8E).withOpacity(0.1),
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
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  education.institution,
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
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              education.degree,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.95),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                education.duration,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                education.location,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
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
