import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/resume/widgets/side_bar.dart';
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
              backgroundColor: const Color(0xFF0A1628),
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
                  color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
              const Color(0xFF0A1628).withAlpha((0.95 * 255).toInt()),
              const Color(0xFF000108).withAlpha((0.90 * 255).toInt()),
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
                      color: Colors.white.withAlpha((0.9 * 255).toInt()),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'RESUME',
                      style: TextStyle(
                        color: Colors.white.withAlpha((0.95 * 255).toInt()),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color(0xFF0A4A8E),
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
                      color: Colors.white.withAlpha((0.5 * 255).toInt()),
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
                        const Color(0xFF0A4A8E).withAlpha((0.5 * 255).toInt()),
                        const Color(0xFF001529).withAlpha((0.4 * 255).toInt()),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0A4A8E).withAlpha((0.6 * 255).toInt())
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
                              ).withAlpha((0.3 * 255).toInt()),
                              const Color(
                                0xFF0A4A8E,
                              ).withAlpha((0.1 * 255).toInt()),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withAlpha((0.8 * 255).toInt()),
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
                          : Colors.white.withAlpha((0.85 * 255).toInt()),
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
                      ).withAlpha((0.8 * 255).toInt()),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0A4A8E,
                          ).withAlpha((0.5 * 255).toInt()),
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
              const Color(0xFF00A843).withAlpha((0.4 * 255).toInt()),
              const Color(0xFF008833).withAlpha((0.3 * 255).toInt()),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00A843).withAlpha((0.4 * 255).toInt()),
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
                      const Color(0xFF00C853).withAlpha((0.3 * 255).toInt()),
                      const Color(0xFF00C853).withAlpha((0.1 * 255).toInt()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.download_rounded,
                  color: Colors.white.withAlpha((0.95 * 255).toInt()),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Download Resume',
                style: TextStyle(
                  color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
            const Color(0xFF6B0000).withAlpha((0.4 * 255).toInt()),
            const Color(0xFF3B0000).withAlpha((0.3 * 255).toInt()),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B0000).withAlpha((0.4 * 255).toInt()),
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
              color: Colors.white.withAlpha((0.95 * 255).toInt()),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Back to Home',
              style: TextStyle(
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
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
                const Color(0xFF0A1628).withAlpha((0.85 * 255).toInt()),
                const Color(0xFF000108).withAlpha((0.75 * 255).toInt()),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.4 * 255).toInt()),
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
                          ).withAlpha((0.85 * 255).toInt()),
                          const Color(
                            0xFF000108,
                          ).withAlpha((0.75 * 255).toInt()),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(
                          0xFF0A4A8E,
                        ).withAlpha((0.3 * 255).toInt()),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.4 * 255).toInt()),
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
