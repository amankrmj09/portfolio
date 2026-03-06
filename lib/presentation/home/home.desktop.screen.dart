import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/infrastructure/navigation/routes.dart';
import 'package:portfolio/presentation/about_me/about_me.screen.dart';
import 'package:portfolio/presentation/home/views/home_floating_menu_bar.dart';

import './widgets/export.home.widget.dart';
import '../../widgets/k.pretty.animated.dart';
import '../../widgets/mesh.background.dart';
import '../certificate/certificate.screen.dart';
import '../footer/footer.screen.dart';
import '../projects/projects.screen.dart';
import 'controllers/home.controller.dart';

class HomeDesktopScreen extends GetView<HomeController> {
  const HomeDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(Colors.black54),
        trackColor: WidgetStateProperty.all(Colors.grey[300]),
        thickness: WidgetStateProperty.all(8),
        radius: const Radius.circular(8),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: const SharedMeshBackground()),
            Theme(
              data: theme,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: Obx(
                  () => Scrollbar(
                    controller: controller.scrollController,
                    thumbVisibility: controller.isScrolling.value,
                    thickness: 8,
                    radius: const Radius.circular(8),
                    interactive: true,
                    child: SingleChildScrollView(
                      key: controller.scrollKey,
                      // Key for accurate offset calculation
                      controller: controller.scrollController,
                      child: Column(
                        children: [
                          _mainSection(context),
                          AboutMeScreen(key: controller.aboutMeKey),
                          HeaderSection(
                            key: controller.recentWorksKey,
                            context: context,
                            title: 'Recent Works',
                            route: Routes.ALL_PROJECTS,
                          ),
                          const ProjectsScreen(),
                          HeaderSection(
                            key: controller.recentCertificatesKey,
                            context: context,
                            title: 'Recent Certificates',
                            route: Routes.ALL_CERTIFICATES,
                          ),
                          const CertificateScreen(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: const FooterScreen(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: _topFloatingBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainSection(BuildContext context) {
    var minHeight = MediaQuery.of(context).size.height > 776
        ? MediaQuery.of(context).size.height
        : 776.0;
    return Center(
      child: SizedBox(
        key: controller.homeKey,
        height: minHeight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 700,
                          minWidth: 200,
                          maxHeight: 340,
                          minHeight: 240,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: KPrettyAnimated(),
                        ),
                      ),
                      AboutMeLines(width: 700, height: 240),
                    ],
                  ),
                  const Spacer(),
                  const CodeBlock(),
                ],
              ),
              NavigateButtonAndSocialLinks(controller: controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topFloatingBar() {
    return Container(
      height: 80,
      width: 640,
      alignment: Alignment.bottomCenter,
      color: Colors.transparent,
      child: Obx(
        () => AnimatedAlign(
          duration: const Duration(milliseconds: 400),
          alignment:
              controller.isScrolling.value &&
                  !controller.isProgrammaticScrolling
              ? const Alignment(0, -5.5)
              : Alignment.bottomCenter,
          child: HomeFloatingMenuBar(),
        ),
      ),
    );
  }
}
