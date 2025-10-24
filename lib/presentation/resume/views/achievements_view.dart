import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/models/resume_model/achievement_model.dart';
import '../controllers/resume.controller.dart';
import '../widgets/shimmer_cards.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ResumeController resumeController = Get.find();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final achievements =
            resumeController.resumeData.value?.achievements ?? [];
        if (achievements.isEmpty) {
          return const ShimmerList();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: achievements
                .map((achievement) => _AchievementCard(achievement))
                .toList(),
          ),
        );
      }),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const _AchievementCard(this.achievement);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // 0 Blackish-Bluish card gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF001529).withAlpha((0.7 * 255).toInt()),
            // Maastricht Blue-Black
            const Color(0xFF000A1F).withAlpha((0.6 * 255).toInt()),
            // Rich Black with blue tint
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withAlpha((0.4 * 255).toInt()),
          // Medium dark blue
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
            // Subtle blue glow
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
                  Icons.emoji_events_rounded,
                  color: Colors.white.withAlpha((0.9 * 255).toInt()),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  achievement.title,
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
              achievement.event,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            achievement.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withAlpha((0.9 * 255).toInt()),
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
