import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/resume/widgets/side_bar.dart';
import '../../widgets/mesh.background.dart';
import 'controllers/resume.controller.dart';

final selectedIndex = 0.obs;
final currentIndex = 0.obs;

class ResumeScreen extends GetView<ResumeController> {
  const ResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(child: SharedMeshBackground()),
          Center(
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
                        child: SideBar(
                          onIndexChanged: (newIndex) {
                            selectedIndex.value = newIndex;
                            Future.delayed(
                              const Duration(milliseconds: 400),
                              () {
                                currentIndex.value = newIndex;
                              },
                            );
                          },
                          menuData: controller.menuData,
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            // ✅ Blackish-Bluish gradient
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(
                                  0xFF0A1628,
                                ).withAlpha((0.85 * 255).toInt()),
                                // Dark blue-black
                                const Color(
                                  0xFF000108,
                                ).withAlpha((0.75 * 255).toInt()),
                                // Rich black with blue tint
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(
                                0xFF0A4A8E,
                              ).withAlpha((0.3 * 255).toInt()),
                              // Dark blue border
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  (0.4 * 255).toInt(),
                                ),
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
                                reverse:
                                    selectedIndex.value < currentIndex.value,
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
                                child: controller
                                    .menuData[selectedIndex.value]['screen'],
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
          ),
        ],
      ),
    );
  }
}
