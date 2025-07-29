import 'dart:ui';

import 'package:atlas_icons/atlas_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portfolio/infrastructure/navigation/routes.dart';
import 'package:portfolio/presentation/about_me/views/profiles_view.dart';
import 'package:portfolio/presentation/about_me/views/tools_view.dart';
import 'package:portfolio/presentation/about_me/widgets/animated.experience.card.dart';
import 'package:portfolio/presentation/about_me/widgets/animated.profil.widget.dart';
import 'package:portfolio/presentation/about_me/widgets/animated.tools.widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/utils/k.showGeneralDialog.dart';

import '../../domain/models/experience_model/experience.model.dart';
import '../../domain/models/profile_links_model/profile.links.model.dart';
import '../../domain/models/tools_model/tools.model.dart';
import '../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../utils/launch.url.dart';
import '../../widgets/animated.navigate.button.dart';
import '../experience/controllers/experience.controller.dart';
import '../home/controllers/home.controller.dart';
import 'controllers/about_me.controller.dart';

class AboutMeScreen extends GetView<AboutMeController> {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
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
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(Colors.transparent, Colors.black, 0.30)!,
                Color.lerp(Colors.transparent, Colors.black, 0.25)!,
                Color.lerp(Colors.transparent, Colors.black, 0.20)!,
                Color.lerp(Colors.transparent, Colors.black, 0.15)!,
                Color.lerp(Colors.transparent, Colors.black, 0.05)!,
                Color.lerp(Colors.transparent, Colors.black, 0.10)!,
                Color.lerp(Colors.transparent, Colors.black, 0.15)!,
                Color.lerp(Colors.transparent, Colors.black, 0.20)!,
                Color.lerp(Colors.transparent, Colors.black, 0.25)!,
                Color.lerp(Colors.transparent, Colors.black, 0.30)!,
                Color.lerp(Colors.transparent, Colors.black, 0.30)!,
                Color.lerp(Colors.transparent, Colors.black, 0.20)!,
              ],
            ),
          ),
          child: Obx(
            () => (controller.isLoading.value || controller.isExpLoading.value)
                ? const Center(child: CircularProgressIndicator())
                : width > 1100
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: AboutMeDetailsColumn(
                                summary:
                                    controller.aboutMeInfo.value?.summary ?? '',
                                profession:
                                    controller.aboutMeInfo.value?.profession ??
                                    '',
                                education:
                                    controller.aboutMeInfo.value?.education ??
                                    '',
                                experience:
                                    controller.aboutMeInfo.value?.experience ??
                                    '',
                                email:
                                    controller.aboutMeInfo.value?.email ?? '',
                                interests:
                                    controller.aboutMeInfo.value?.interests ??
                                    [],
                                technicalInterests:
                                    controller
                                        .aboutMeInfo
                                        .value
                                        ?.technicalInterests ??
                                    [],
                              ),
                            ),
                            const SizedBox(width: 60),
                            Flexible(
                              flex: 3,
                              child: AboutMeToolsColumn(
                                profiles: controller.profiles,
                                tools: controller.tools,
                                experiences: controller.experiences,
                              ),
                            ),
                          ],
                        ),
                      ],
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
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        controller: controller.scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AboutMeDetailsColumn(
                              summary:
                                  controller.aboutMeInfo.value?.summary ?? '',
                              profession:
                                  controller.aboutMeInfo.value?.profession ??
                                  '',
                              education:
                                  controller.aboutMeInfo.value?.education ?? '',
                              experience:
                                  controller.aboutMeInfo.value?.experience ??
                                  '',
                              email: controller.aboutMeInfo.value?.email ?? '',
                              interests:
                                  controller.aboutMeInfo.value?.interests ?? [],
                              technicalInterests:
                                  controller
                                      .aboutMeInfo
                                      .value
                                      ?.technicalInterests ??
                                  [],
                            ),
                            const SizedBox(height: 24),
                            AboutMeToolsColumn(
                              tools: controller.tools,
                              experiences: controller.experiences,
                              profiles: controller.profiles,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class AboutMeDetailsColumn extends StatelessWidget {
  final String summary;
  final String profession;
  final String education;
  final String experience;
  final String email;
  final List<String> interests;
  final List<String> technicalInterests;

  const AboutMeDetailsColumn({
    super.key,
    required this.summary,
    required this.profession,
    required this.education,
    required this.experience,
    required this.email,
    required this.interests,
    required this.technicalInterests,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (summary.trim().isNotEmpty)
          Text(
            summary,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: isMobile ? 12 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        const SizedBox(height: 24),
        if (profession.trim().isNotEmpty)
          Wrap(
            spacing: 2,
            runSpacing: 6,
            children: [
              const Icon(Icons.work_outline, size: 20),
              const SizedBox(width: 8),
              Text('Profession: ', style: const TextStyle(fontSize: 16)),
              Text(profession, style: const TextStyle(fontSize: 16)),
            ],
          ),
        const SizedBox(height: 12),
        if (education.trim().isNotEmpty)
          Wrap(
            spacing: 2,
            runSpacing: 6,
            children: [
              const Icon(Icons.school_outlined, size: 20),
              const SizedBox(width: 8),
              Text('Education: ', style: const TextStyle(fontSize: 16)),
              Text(education, style: const TextStyle(fontSize: 16)),
            ],
          ),
        const SizedBox(height: 12),
        if (experience.trim().isNotEmpty)
          Row(
            children: [
              const Icon(Icons.timeline, size: 20),
              const SizedBox(width: 8),
              Text(
                'Experience: $experience',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        const SizedBox(height: 12),
        if (email.trim().isNotEmpty)
          Row(
            children: [
              const Icon(Icons.email_outlined, size: 20),
              const SizedBox(width: 8),
              Text('Email: $email', style: const TextStyle(fontSize: 16)),
            ],
          ),
        const SizedBox(height: 16),
        if (interests.isNotEmpty)
          const Text(
            'What I love to do:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'ShantellSans',
            ),
          ),
        if (interests.isNotEmpty) const SizedBox(height: 8),
        if (interests.isNotEmpty)
          Wrap(
            spacing: 8,
            children: interests
                .map(
                  (interest) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.black, Colors.transparent, 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white60),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          interest.toString(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                        // const SizedBox(width: 8),
                        // Icon(
                        //   Atlas.settings_laptop_bold,
                        //   color: Colors.red,
                        //   size: 16,
                        // ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        if (technicalInterests.isNotEmpty) const SizedBox(height: 16),
        if (technicalInterests.isNotEmpty)
          const Text(
            'Technical Interest:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'ShantellSans',
            ),
          ),
        if (technicalInterests.isNotEmpty) const SizedBox(height: 8),
        if (technicalInterests.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: technicalInterests
                .map(
                  (technicalInterest) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.black, Colors.transparent, 0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white60),
                    ),
                    child: Text(
                      technicalInterest.toString(),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class AboutMeToolsColumn extends StatelessWidget {
  final List<ToolsModel> tools;
  final List<ExperienceModel> experiences;
  final List<ProfileLinksModel> profiles;

  const AboutMeToolsColumn({
    super.key,
    required this.profiles,
    required this.tools,
    required this.experiences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  '   Tools I Use:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ShantellSans',
                  ),
                ),
                IconButton(
                  tooltip: 'View All',
                  onPressed: () {
                    showBlurredGeneralDialog(
                      context: context,
                      builder: (context) {
                        return const ToolsView();
                      },
                    );
                  },
                  icon: Icon(Icons.dashboard),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedToolsWidget(tools: tools),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '   Find me on:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'ShantellSans',
                  ),
                ),
                IconButton(
                  tooltip: 'View All',
                  onPressed: () {
                    showBlurredGeneralDialog(
                      context: context,
                      builder: (context) {
                        return const ProfilesView();
                      },
                    );
                  },
                  icon: Icon(Icons.dashboard),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedProfileWidget(profiles: profiles),
          ],
        ),
        InkWell(
          onTap: () {
            if (!Get.isRegistered<ExperienceController>()) {
              Get.put(ExperienceController());
            }
            Get.toNamed(Routes.EXPERIENCE);
          },
          child: LayoutBuilder(
            builder: (context, constraints) => AnimatedExperienceCard(
              experiences: experiences,
              width: constraints.maxWidth,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: viewResumeButton(),
        ),
      ],
    );
  }

  Container viewResumeButton() {
    final homeController = Get.find<HomeController>();
    return Container(
      alignment: Alignment.center,
      height: 140,
      width: 200,
      child: AnimatedNavigateButton(
        borderRadius: 16,
        label: "View Resume",
        onTap: () =>
            launchUrlExternal(homeController.socialLinks.value?.resume ?? ''),
        icon: SvgPicture.asset(
          'assets/icons/resume.svg',
          width: 28,
          height: 28,
        ),
        width: 200,
      ),
    );
  }
}
