import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:portfolio/infrastructure/navigation/routes.dart';
import 'package:portfolio/presentation/about_me/views/profiles_view.dart';
import 'package:portfolio/presentation/about_me/views/tools_view.dart';
import 'package:portfolio/presentation/about_me/widgets/animated.experience.card.dart';
import 'package:portfolio/presentation/about_me/widgets/animated.profil.widget.dart';
import 'package:portfolio/presentation/about_me/widgets/animated.tools.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/about_me/widgets/k.shimmer.about_me.dart';
import 'package:portfolio/utils/k.showGeneralDialog.dart';
import 'package:portfolio/utils/k.smoothscrollweb.dart';
import '../../domain/models/experience_model/experience.model.dart';
import '../../domain/models/profile_links_model/profile.links.model.dart';
import '../../domain/models/tools_model/tools.model.dart';
import '../../infrastructure/theme/colors.dart';
import '../../widgets/animated.navigate.button.dart';
import '../home/controllers/home.controller.dart';
import 'controllers/about_me.controller.dart';

class AboutMeScreen extends GetView<AboutMeController> {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Get.find<HomeController>();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 68,
            bottom: 16,
          ),
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                KColor.darkNavy.withValues(alpha: 0.85),
                KColor.deepNavy.withValues(alpha: 0.75),
                KColor.deepestNavy.withValues(alpha: 0.65),
              ],
            ),
            border: Border.all(
              color: KColor.accentBlue.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Obx(
            () => (!controller.isAllLoaded)
                ? const KShimmerAboutMe()
                : width > 1100
                ? KSmoothScrollWeb(
                    controller: controller.scrollController,
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column - Profile Header + Stats
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileHeader(
                                  controller.aboutMeInfo.value?.profession ??
                                      'Developer',
                                  controller.aboutMeInfo.value?.email ?? '',
                                ),
                                const SizedBox(height: 32),
                                _buildSummarySection(
                                  controller.aboutMeInfo.value?.summary ?? '',
                                ),
                                const SizedBox(height: 32),
                                _buildInterestsSections(
                                  controller.aboutMeInfo.value?.interests ?? [],
                                  controller
                                          .aboutMeInfo
                                          .value
                                          ?.technicalInterests ??
                                      [],
                                ),
                                const SizedBox(height: 24),
                                _buildResumeButton(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                          // Right Column - Summary + Tools + Experience
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildStatsCards(
                                  controller.aboutMeInfo.value?.experience ??
                                      '',
                                  controller.aboutMeInfo.value?.education ?? '',
                                ),
                                const SizedBox(height: 32),
                                _buildSocialLinksSection(controller.profiles),
                                const SizedBox(height: 32),
                                _buildToolsSection(context, controller.tools),
                                const SizedBox(height: 32),
                                _buildExperienceSection(controller.experiences),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      scrollbars: false,
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: Listener(
                      onPointerSignal: (pointerSignal) {
                        controller.handlePointerSignal(pointerSignal);
                      },
                      onPointerMove: (pointerEvent) {
                        controller.handlePointerMove(pointerEvent);
                      },
                      onPointerDown: (pointerEvent) {
                        controller.handlePointerDown(pointerEvent);
                      },
                      child: KSmoothScrollWeb(
                        controller: controller.scrollController,
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          controller: controller.scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileHeader(
                                controller.aboutMeInfo.value?.profession ??
                                    'Developer',
                                controller.aboutMeInfo.value?.email ?? '',
                              ),
                              const SizedBox(height: 24),
                              _buildStatsCards(
                                controller.aboutMeInfo.value?.experience ?? '',
                                controller.aboutMeInfo.value?.education ?? '',
                              ),
                              const SizedBox(height: 24),
                              _buildSummarySection(
                                controller.aboutMeInfo.value?.summary ?? '',
                              ),
                              const SizedBox(height: 24),
                              _buildInterestsSections(
                                controller.aboutMeInfo.value?.interests ?? [],
                                controller
                                        .aboutMeInfo
                                        .value
                                        ?.technicalInterests ??
                                    [],
                              ),
                              const SizedBox(height: 24),
                              _buildSocialLinksSection(controller.profiles),
                              const SizedBox(height: 24),
                              _buildToolsSection(context, controller.tools),
                              const SizedBox(height: 24),
                              _buildExperienceSection(controller.experiences),
                              const SizedBox(height: 20),
                              _buildResumeButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // Profile Header with Title and Email
  Widget _buildProfileHeader(String profession, String email) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KColor.accentBlue.withValues(alpha: 0.25),
            KColor.deepNavy.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: KColor.accentBlue.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: KColor.accentBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 28,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profession,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ShantellSans',
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (email.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              email,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Stats Cards for Experience and Education
  Widget _buildStatsCards(String experience, String education) {
    return Row(
      children: [
        if (experience.isNotEmpty)
          Expanded(
            child: _buildStatCard(Icons.timeline, 'Experience', experience),
          ),
        if (experience.isNotEmpty && education.isNotEmpty)
          const SizedBox(width: 16),
        if (education.isNotEmpty)
          Expanded(
            child: _buildStatCard(
              Icons.school_outlined,
              'Education',
              education,
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KColor.accentBlue.withValues(alpha: 0.2),
            KColor.deepNavy.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: KColor.accentBlue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }

  // Summary Section
  Widget _buildSummarySection(String summary) {
    if (summary.trim().isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: KColor.accentBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'About Me',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'ShantellSans',
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                KColor.accentBlue.withValues(alpha: 0.15),
                KColor.deepNavy.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: KColor.accentBlue.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Text(
            summary,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.7,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  // Interests Sections
  Widget _buildInterestsSections(
    List<String> interests,
    List<String> technicalInterests,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (interests.isNotEmpty) ...[
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: KColor.accentBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Interests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ShantellSans',
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: interests
                .map(
                  (interest) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0A4A8E).withValues(alpha: 0.3),
                          const Color(0xFF001529).withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF0A4A8E).withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      interest.toString(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
        if (interests.isNotEmpty && technicalInterests.isNotEmpty)
          const SizedBox(height: 24),
        if (technicalInterests.isNotEmpty) ...[
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: KColor.accentBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Technical Skills',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ShantellSans',
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: technicalInterests
                .map(
                  (technicalInterest) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0A4A8E).withValues(alpha: 0.3),
                          const Color(0xFF001529).withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF0A4A8E).withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      technicalInterest.toString(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  // Social Links Section
  Widget _buildSocialLinksSection(List<ProfileLinksModel> profiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: KColor.accentBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Connect',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ShantellSans',
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
            Builder(
              builder: (context) => IconButton(
                tooltip: 'View All',
                onPressed: () {
                  showBlurredGeneralDialog(
                    context: context,
                    builder: (context) => const ProfilesView(),
                  );
                },
                icon: Icon(
                  Icons.open_in_new,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedProfileWidget(profiles: profiles),
      ],
    );
  }

  // Tools Section
  Widget _buildToolsSection(BuildContext context, List<ToolsModel> tools) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: KColor.accentBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Tech Stack',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ShantellSans',
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
            IconButton(
              tooltip: 'View All',
              onPressed: () {
                showBlurredGeneralDialog(
                  context: context,
                  builder: (context) => const ToolsView(),
                );
              },
              icon: Icon(
                Icons.open_in_new,
                size: 20,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedToolsWidget(tools: tools),
      ],
    );
  }

  // Experience Section
  Widget _buildExperienceSection(List<ExperienceModel> experiences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: KColor.accentBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Journey So Far',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'ShantellSans',
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) => AnimatedExperienceCard(
            experiences: experiences,
            width: constraints.maxWidth,
          ),
        ),
      ],
    );
  }

  // Resume Button
  Widget _buildResumeButton() {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: 120,
        // Use a fixed height or adjust as needed
        child: AnimatedNavigateButton(
          borderRadius: 16,
          label: "View Resume",
          onTap: () => Get.toNamed(Routes.RESUME),
          icon: SvgPicture.asset(
            'assets/icons/resume.svg',
            width: 28,
            height: 28,
          ),
          width: 220,
        ),
      ),
    );
  }
}
