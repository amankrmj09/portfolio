import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:portfolio/presentation/admin/views/contact_screen_view.dart';

import '../../config.dart';
import '../../presentation/admin/admin.screen.dart';
import '../../presentation/certificate/views/all_certificates_view.dart';
import '../../presentation/home/home.screen.dart';
import '../../presentation/screens.dart';
import '../../presentation/works/views/all_wroks_view.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;

  const EnvironmentsBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.CERTIFICATE,
      page: () => const CertificateScreen(),
      binding: CertificateControllerBinding(),
    ),
    GetPage(
      name: Routes.WORKS,
      page: () => const WorksScreen(),
      binding: WorksControllerBinding(),
    ),
    GetPage(
      name: Routes.FOOTER,
      page: () => const FooterScreen(),
      binding: FooterControllerBinding(),
    ),
    GetPage(
      name: Routes.EXPERIENCE,
      page: () => const ExperienceScreen(),
      binding: ExperienceControllerBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.CONTACT,
      page: () => ContactScreenView(string: Get.arguments as String),
      binding: AdminControllerBinding(),
      transition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.ADMIN,
      page: () => const AdminScreen(),
      binding: AdminControllerBinding(),
    ),
    GetPage(
      name: Routes.ABOUT_ME,
      page: () => const AboutMeScreen(),
      binding: AboutMeControllerBinding(),
    ),
    GetPage(
      name: Routes.ALL_PROJECTS,
      page: () => const AllWorksView(),
      binding: WorksControllerBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.ALL_CERTIFICATES,
      page: () => const AllCertificatesView(),
      binding: CertificateControllerBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.CLI,
      page: () => const CliScreen(),
      binding: CliControllerBinding(),
    ),
    GetPage(
      name: Routes.RESUME,
      page: () => const ResumeScreen(),
      binding: ResumeControllerBinding(),
    ),
    GetPage(
      name: Routes.PROFILES,
      page: () => const ProfilesScreen(),
      binding: ProfilesControllerBinding(),
    ),
  ];
}
