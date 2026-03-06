import 'package:flutter/material.dart';
import '../../../widgets/animated.navigate.button.dart';
import '../controllers/home.controller.dart';
import 'social_links_row.widget.dart';

/// Navigate Button and Social Links Row Widget
class NavigateButtonAndSocialLinks extends StatelessWidget {
  final HomeController controller;

  const NavigateButtonAndSocialLinks({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
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
              onTap: controller.onTapActions[2],
              // Index 2 is recentWorksKey
              width: 210,
            ),
          ),
          const SocialLinksRow(),
        ],
      ),
    );
  }
}
