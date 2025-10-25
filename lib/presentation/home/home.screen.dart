import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/info.fetch.controller.dart';

import 'home.desktop.screen.dart';
import 'home.mobile.screen.dart';
import 'home.tablet.screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final width = MediaQuery.of(context).size.width;
    if (width < 900) {
      infoFetchController.currentDevice.value = Device.Mobile;
      return const HomeMobileScreen();
    } else if (width < 1300) {
      infoFetchController.currentDevice.value = Device.Tablet;
      return const HomeTabletScreen();
    } else {
      infoFetchController.currentDevice.value = Device.Desktop;
      return HomeDesktopScreen();
    }
  }
}
