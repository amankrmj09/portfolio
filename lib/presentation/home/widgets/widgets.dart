import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:portfolio/infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../configs/constant_strings.dart';
import '../../../widgets/animated.navigate.button.dart';
import '../controllers/home.controller.dart';
import 'animated.rotate.icon.dart';

/// Animated Social Icon
Widget animatedIcon({
  required String outline,
  required String color,
  required String label,
  required String url,
  Color? iconColor = Colors.white54,
}) {
  return AnimatedRotateIcon(
    firstIcon: SvgPicture.asset(
      outline,
      width: 32,
      height: 32,
      colorFilter: ColorFilter.mode(iconColor ?? Colors.black, BlendMode.srcIn),
    ),
    secondIcon: SvgPicture.asset(color, width: 32, height: 32),
    label: label,
    url: url,
  );
}

/// Vertical Divider
Widget verticalDivider() {
  return const VerticalDivider(
    indent: 6,
    endIndent: 12,
    width: 16,
    thickness: 2,
    color: Colors.black,
    radius: BorderRadius.all(Radius.circular(40)),
  );
}

/// Social Links Row
Widget socialLinksRow() {
  final InfoFetchController infoController = Get.find<InfoFetchController>();
  final links = infoController.socialLinks.value;
  final isMobile = infoController.currentDevice.value == Device.Mobile;
  return SizedBox(
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        animatedIcon(
          outline: 'assets/icons/github_outline_white.svg',
          color: 'assets/icons/github_color.svg',
          label: isMobile ? "" : "Github",
          url: links?.github ?? '',
        ),
        verticalDivider(),
        animatedIcon(
          outline: 'assets/icons/linkedin_outline_white.svg',
          color: 'assets/icons/linkedin_color.svg',
          label: isMobile ? "" : "LinkedIn",
          url: links?.linkedIn ?? '',
        ),
        verticalDivider(),
        animatedIcon(
          outline: 'assets/icons/instagram_outline_white.svg',
          color: 'assets/icons/instagram_color.svg',
          label: isMobile ? "" : "Instagram",
          url: links?.instagram ?? '',
        ),
        verticalDivider(),
        animatedIcon(
          outline: 'assets/icons/discord_outline_white.svg',
          color: 'assets/icons/discord_color.svg',
          label: isMobile ? "" : "Discord",
          url: links?.discord ?? '',
        ),
      ],
    ),
  );
}

/// About Me Lines
Widget aboutMeLines({double? width, double? height}) {
  return SizedBox(
    height: height ?? 200,
    width: width ?? 500,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "$kHomeDisplayLineAboutMe01\n",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: "ShantellSans",
            ),
            children: [
              TextSpan(
                text: "$kHomeDisplayLineAboutMe02\n",
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: "$kHomeDisplayLineAboutMe03\n",
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Navigate Button and Social Links Row
Widget navigateButtonAndSocialLinks(HomeController controller) {
  return SizedBox(
    height: 100,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 240,
          child: AnimatedNavigateButton(
            borderRadius: 20,
            label: 'See My Works',
            icon: const Icon(Icons.arrow_forward, size: 24),
            onTap: () {
              final ctx = HomeController.recentWorksKey.currentContext;
              if (ctx != null) {
                Scrollable.ensureVisible(
                  ctx,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  alignment: 0.0,
                );
              }
            },
            width: 210,
          ),
        ),
        socialLinksRow(),
      ],
    ),
  );
}
