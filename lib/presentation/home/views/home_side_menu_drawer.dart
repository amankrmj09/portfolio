import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/footer/footer.screen.dart';

import '../../../utils/k.showGeneralDialog.dart';
import '../../../widgets/animated.navigate.button.dart';
import '../../footer/views/contact_me_view.dart';
import '../controllers/home.controller.dart';

class HomeSideMenuDrawer extends StatelessWidget {
  const HomeSideMenuDrawer({super.key});

  final List<String> labels = const [
    'Home',
    'Works',
    'Certificates',
    'About Me',
  ];
  final List<IconData> icons = const [
    Icons.home,
    Icons.work,
    Icons.school,
    Icons.badge,
  ];

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final onTapActions = controller.onTapActions;
    final selectedIndex = controller.selectedTabIndex;
    // Always return Drawer
    return Drawer(
      backgroundColor: const Color(0xFF1A1A2E),
      width: MediaQuery.of(context).size.width * 0.8,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 8,
                ),
                itemCount: labels.length,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  return Obx(() {
                    final isSelected = selectedIndex.value == index;
                    return ListTile(
                      leading: Icon(
                        icons[index],
                        color: isSelected
                            ? const Color(0xFF43C6AC)
                            : Colors.white70,
                      ),
                      title: Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Color(0xFF43C6AC)
                              : Colors.white70,
                        ),
                      ),
                      onTap: () async {
                        onTapActions[index](); // Then perform the action
                        await Future.delayed(const Duration(milliseconds: 300));
                        if (context.mounted) {
                          Navigator.of(context).pop(); // Close the drawer
                        }
                      },
                      selected: isSelected,
                      selectedTileColor: Color.lerp(
                        Colors.transparent,
                        Colors.white,
                        0.4,
                      ),
                      contentPadding: EdgeInsetsGeometry.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  });
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: 250,
                  child: Builder(
                    builder: (context) => AnimatedNavigateButton(
                      borderRadius: 16,
                      label: "Send Me a Message",
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        if (context.mounted) {
                          showBlurredGeneralDialog(
                            context: context,
                            builder: (context) => ContactMeView(),
                          );
                        }
                      },
                      icon: Image.asset(
                        'assets/icons/contact_me.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.fitHeight,
                      ),
                      width: 250,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FooterWidgets.ccLabel(Colors.white),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
