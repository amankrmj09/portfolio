import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../widgets/animated.navigate.button.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final GlobalKey sectionKey;
  final BuildContext context;
  final String? route;
  final double? height;

  const HeaderSection({
    super.key,
    required this.title,
    required this.sectionKey,
    this.route,
    required this.context,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    final InfoFetchController controller = Get.find<InfoFetchController>();
    final bool isTablet = controller.currentDevice.value == Device.Tablet;
    final bool isMobile = controller.currentDevice.value == Device.Mobile;

    return Obx(
      () => Container(
        key: sectionKey,
        height: isMobile ? 40 : height,
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          crossAxisAlignment: isTablet
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "ShantellSans",
                fontWeight: FontWeight.bold,
                fontSize: controller.currentDevice.value == Device.Mobile
                    ? 24
                    : 32,
                letterSpacing: 1.2,
                decoration: TextDecoration.none,
              ),
            ),
            isMobile
                ? IconButton(
                    onPressed: () => Get.toNamed(route!),
                    icon: const Icon(Icons.dashboard),
                  )
                : Container(
                    alignment: Alignment.centerLeft,
                    width: 190,
                    child: AnimatedNavigateButton(
                      label: "Browse All",
                      reset: true,
                      icon: const Icon(Icons.arrow_forward),
                      borderRadius: 12,
                      onTap: () => Get.toNamed(route!),
                      width: 190,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
