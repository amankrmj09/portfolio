import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/infrastructure/theme/colors.dart';

import '../../infrastructure/navigation/routes.dart';
import './widgets/export.home.widget.dart';
import 'package:portfolio/presentation/home/views/home_side_menu_drawer.dart';
import '../../widgets/k.pretty.animated.dart';
import '../../widgets/mesh.background.dart';
import 'controllers/home.controller.dart';
import '../screens.dart';

class HomeMobileScreen extends GetView<HomeController> {
  const HomeMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: KColor.darkScaffold),
      drawer: const HomeSideMenuDrawer(),
      backgroundColor: KColor.darkScaffold,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(child: SharedMeshBackground()),
          SingleChildScrollView(
            key: controller.scrollKey, // Key for accurate offset calculation
            controller: controller.scrollController,
            child: Obx(
              () => Scrollbar(
                controller: controller.scrollController,
                thumbVisibility: controller.isScrolling.value,
                thickness: 8,
                radius: const Radius.circular(8),
                interactive: true,
                child: Column(
                  children: [
                    _mainSection(context),
                    const SizedBox(height: 10),
                    HeaderSection(
                      context: context,
                      title: 'Recent Works',
                      route: Routes.ALL_PROJECTS,
                      key: controller.recentWorksKey,
                    ),
                    const SizedBox(height: 10),
                    const ProjectsScreen(),
                    const SizedBox(height: 20),
                    HeaderSection(
                      context: context,
                      title: 'Recent Certificates',
                      route: Routes.ALL_CERTIFICATES,
                      key: controller.recentCertificatesKey,
                    ),
                    const SizedBox(height: 10),
                    const CertificateScreen(),
                    const SizedBox(height: 20),
                    AboutMeScreen(key: controller.aboutMeKey),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const FooterScreen(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      key: controller.homeKey,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 400 ? 16.0 : 24.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Added this
          children: [
            const SizedBox(height: 40), // Adjusted spacing

            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth - 48,
                maxHeight: 200,
              ),
              child: const Center(child: KPrettyAnimated()),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: AboutMeLines(width: screenWidth, height: 150),
            ),

            // Code block
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: AbsorbPointer(
                child: SizedBox(
                  width: screenWidth * 0.7,
                  child: const FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: CodeBlock(),
                  ),
                ),
              ),
            ),

            // Social links
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SocialLinksRow(),
            ),
          ],
        ),
      ),
    );
  }
}
