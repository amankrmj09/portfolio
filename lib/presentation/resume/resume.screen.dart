import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/resume/widgets/side_bar.dart';
import '../../infrastructure/theme/colors.dart';
import '../../widgets/mesh.background.dart';
import '../../utils/launch.url.dart';
import '../../utils/k.snackbar.dart';
import 'controllers/resume.controller.dart';

final selectedIndex = 0.obs;
final currentIndex = 0.obs;

class ResumeScreen extends GetView<ResumeController> {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isMobile
          ? AppBar(
              backgroundColor: KColor.darkNavy,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Text(
                'RESUME',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              centerTitle: true,
            )
          : null,
      drawer: isMobile ? _buildMobileDrawer() : null,
      body: Stack(
        children: [
          Positioned.fill(child: SharedMeshBackground()),
          isMobile ? _buildMobileView() : _buildDesktopView(context),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              KColor.darkNavy.withValues(alpha: 0.95),
              KColor.nearBlack.withValues(alpha: 0.90),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'RESUME',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: KColor.accentBlue,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 8),
              // Navigation Label
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'NAVIGATION',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              // Menu Items
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: controller.menuData.length,
                    itemBuilder: (context, index) {
                      final item = controller.menuData[index];
                      final isSelected = selectedIndex.value == index;
                      return _buildMobileMenuItem(
                        title: item['title'] as String,
                        icon: item['icon'] as IconData,
                        index: index,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),
              ),
              // Download Resume Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: _buildMobileDownloadButton(),
              ),
              // Back Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: _buildMobileBackButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem({
    required String title,
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            selectedIndex.value = index;
            Future.delayed(const Duration(milliseconds: 400), () {
              currentIndex.value = index;
            });
            Get.back(); // Close drawer
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        KColor.accentBlue.withValues(alpha: 0.5),
                        KColor.deepNavy.withValues(alpha: 0.4),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? KColor.accentBlue.withValues(alpha: 0.6)
                    : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              const Color(
                                0xFF0A4A8E,
                              ).withValues(alpha: 0.3),
                              const Color(
                                0xFF0A4A8E,
                              ).withValues(alpha: 0.1),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.8),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.85),
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF0A4A8E,
                      ).withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0A4A8E,
                          ).withValues(alpha: 0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDownloadButton() {
    return Obx(() {
      final resumeUrl = controller.socialLinks.value?.resume;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              KColor.mediumGreen.withValues(alpha: 0.4),
              KColor.darkGreen.withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: KColor.mediumGreen.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: () {
            if (resumeUrl != null && resumeUrl.isNotEmpty) {
              launchUrlExternal(resumeUrl);
            } else {
              kSnackbar(
                title: 'Resume URL',
                message:
                    'Some error occurred while trying to download the resume.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                titleColor: Colors.white,
                messageColor: Colors.white,
                prefixIcon: Icons.error_outline,
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      KColor.successGreen.withValues(alpha: 0.3),
                      KColor.successGreen.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.download_rounded,
                  color: Colors.white.withValues(alpha: 0.95),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Download Resume',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMobileBackButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            KColor.darkRedAlt.withValues(alpha: 0.4),
            KColor.darkestRed.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: KColor.darkRed.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => Get.back(),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_rounded,
              color: Colors.white.withValues(alpha: 0.95),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Back to Home',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                KColor.darkNavy.withValues(alpha: 0.85),
                KColor.nearBlack.withValues(alpha: 0.75),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: KColor.accentBlue.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Obx(
              () => PageTransitionSwitcher(
                reverse: selectedIndex.value < currentIndex.value,
                transitionBuilder:
                    (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                child:
                    controller.menuData[selectedIndex.value]['screen']
                        as Widget,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Obx(
                    () => SideBar(
                      onIndexChanged: (newIndex) {
                        selectedIndex.value = newIndex;
                        Future.delayed(const Duration(milliseconds: 400), () {
                          currentIndex.value = newIndex;
                        });
                      },
                      menuData: controller.menuData,
                      resumeUrl: controller.socialLinks.value?.resume,
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(
                            0xFF0A1628,
                          ).withValues(alpha: 0.85),
                          const Color(
                            0xFF000108,
                          ).withValues(alpha: 0.75),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(
                          0xFF0A4A8E,
                        ).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Obx(
                        () => PageTransitionSwitcher(
                          reverse: selectedIndex.value < currentIndex.value,
                          transitionBuilder:
                              (
                                Widget child,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                              ) {
                                return SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.vertical,
                                  fillColor: Colors.transparent,
                                  child: child,
                                );
                              },
                          child:
                              controller.menuData[selectedIndex.value]['screen']
                                  as Widget,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
