import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:portfolio/presentation/about_me/controllers/about_me.controller.dart';

import '../widgets/profile.widget.dart';

class ProfilesView extends GetView<AboutMeController> {
  const ProfilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.black, Colors.transparent, 0.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  'Profiles',
                  style: TextStyle(
                    fontFamily: 'ShantellSans',
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 32.0,
                  runSpacing: 8.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ...(List.from(controller.profiles)..shuffle()).map(
                      (profile) => ProfileWidget(profile: profile),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
