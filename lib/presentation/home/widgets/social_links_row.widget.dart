import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/info.fetch.controller.dart';
import 'animated_icon.widget.dart';
import 'vertical_divider.widget.dart';

/// Social Links Row Widget
class SocialLinksRow extends StatelessWidget {
  const SocialLinksRow({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoController = Get.find<InfoFetchController>();
    final links = infoController.socialLinks.value;
    final isMobile = infoController.currentDevice.value == Device.Mobile;

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSocialIcon(
            outline: 'assets/icons/github_outline_white.svg',
            color: 'assets/icons/github_color.svg',
            label: isMobile ? "" : "Github",
            url: links?.github ?? '',
          ),
          const CustomVerticalDivider(),
          AnimatedSocialIcon(
            outline: 'assets/icons/linkedin_outline_white.svg',
            color: 'assets/icons/linkedin_color.svg',
            label: isMobile ? "" : "LinkedIn",
            url: links?.linkedIn ?? '',
          ),
          const CustomVerticalDivider(),
          AnimatedSocialIcon(
            outline: 'assets/icons/instagram_outline_white.svg',
            color: 'assets/icons/instagram_color.svg',
            label: isMobile ? "" : "Instagram",
            url: links?.instagram ?? '',
          ),
          const CustomVerticalDivider(),
          AnimatedSocialIcon(
            outline: 'assets/icons/discord_outline_white.svg',
            color: 'assets/icons/discord_color.svg',
            label: isMobile ? "" : "Discord",
            url: links?.discord ?? '',
          ),
        ],
      ),
    );
  }
}
