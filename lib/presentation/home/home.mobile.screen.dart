import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './widgets/export.home.widget.dart';
import 'package:portfolio/presentation/home/views/home_side_menu_drawer.dart';
import '../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../widgets/k.pretty.animated.dart';
import '../../widgets/mesh.background.dart';
import 'controllers/home.controller.dart';
import '../screens.dart';

class HomeMobileScreen extends GetView<HomeController> {
  const HomeMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    // ignore: unused_local_variable
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF1A1A2E)),

      drawer: HomeSideMenuDrawer(),
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: SharedMeshBackground()),
          SingleChildScrollView(
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
                      sectionKey: HomeController.recentWorksKey,
                    ),
                    const SizedBox(height: 10),
                    const WorksScreen(),
                    const SizedBox(height: 20),

                    HeaderSection(
                      context: context,
                      title: 'Recent Certificates',
                      sectionKey: HomeController.recentCertificatesKey,
                    ),
                    const SizedBox(height: 10),
                    const CertificateScreen(),
                    const SizedBox(height: 20),
                    SizedBox(
                      key: HomeController.aboutMeKey,
                      height: MediaQuery.of(context).size.height,
                      child: const AboutMeScreen(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: FooterScreen(),
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
    return Center(
      child: SizedBox(
        key: HomeController.homeKey,
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: kToolbarHeight),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    child: KPrettyAnimated(),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                child: aboutMeLines(width: 500, height: 200),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
                child: CodeBlock(),
              ),
              socialLinksRow(),
            ],
          ),
        ),
      ),
    );
  }
}
