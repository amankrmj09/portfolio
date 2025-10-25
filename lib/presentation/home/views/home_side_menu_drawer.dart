import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/footer/footer.screen.dart';
import '../../../utils/k.showGeneralDialog.dart';
import '../../../widgets/animated.navigate.button.dart';
import '../../footer/views/contact_me_view.dart';
import '../controllers/home.controller.dart';

class HomeSideMenuDrawer extends StatefulWidget {
  const HomeSideMenuDrawer({super.key});

  @override
  State<HomeSideMenuDrawer> createState() => _HomeSideMenuDrawerState();
}

class _HomeSideMenuDrawerState extends State<HomeSideMenuDrawer> {
  final List<String> labels = const [
    'Home',
    'Works',
    'Certificates',
    'About Me',
  ];

  final List<IconData> icons = const [
    Icons.home_rounded,
    Icons.work_rounded,
    Icons.school_rounded,
    Icons.badge_rounded,
  ];

  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final onTapActions = controller.onTapActions;
    final selectedIndex = controller.selectedTabIndex;

    return Drawer(
      // ✅ Blackish-bluish background
      backgroundColor: const Color(0xFF0A1628),
      width: MediaQuery.of(context).size.width * 0.85,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A1628).withAlpha((0.95 * 255).round()),
              const Color(0xFF001529).withAlpha((0.9 * 255).round()),
              const Color(0xFF000A1F).withAlpha((0.85 * 255).round()),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(
                        0xFF0A4A8E,
                      ).withAlpha((0.3 * 255).round()),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(
                              0xFF0A4A8E,
                            ).withAlpha((0.3 * 255).round()),
                            const Color(
                              0xFF001529,
                            ).withAlpha((0.2 * 255).round()),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Colors.white.withAlpha((0.9 * 255).round()),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'NAVIGATION',
                      style: TextStyle(
                        color: Colors.white.withAlpha((0.9 * 255).round()),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final isSelected = selectedIndex.value == index;
                      final isHovered = hoveredIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MouseRegion(
                          onEnter: (_) => setState(() => hoveredIndex = index),
                          onExit: (_) => setState(() => hoveredIndex = null),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: isSelected
                                    ? [
                                        const Color(
                                          0xFF0A4A8E,
                                        ).withAlpha((0.5 * 255).round()),
                                        const Color(
                                          0xFF001529,
                                        ).withAlpha((0.4 * 255).round()),
                                      ]
                                    : isHovered
                                    ? [
                                        const Color(
                                          0xFF001529,
                                        ).withAlpha((0.4 * 255).round()),
                                        const Color(
                                          0xFF000A1F,
                                        ).withAlpha((0.3 * 255).round()),
                                      ]
                                    : [
                                        const Color(
                                          0xFF000A1F,
                                        ).withAlpha((0.2 * 255).round()),
                                        const Color(
                                          0xFF000000,
                                        ).withAlpha((0.1 * 255).round()),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(
                                        0xFF0A4A8E,
                                      ).withAlpha((0.6 * 255).round())
                                    : isHovered
                                    ? const Color(
                                        0xFF0A4A8E,
                                      ).withAlpha((0.3 * 255).round())
                                    : Colors.transparent,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF0A4A8E,
                                        ).withAlpha((0.3 * 255).round()),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  onTapActions[index]();
                                  await Future.delayed(
                                    const Duration(milliseconds: 300),
                                  );
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                splashColor: const Color(
                                  0xFF0A4A8E,
                                ).withAlpha((0.2 * 255).round()),
                                highlightColor: const Color(
                                  0xFF0A4A8E,
                                ).withAlpha((0.1 * 255).round()),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
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
                                                    ).withAlpha(
                                                      (0.3 * 255).round(),
                                                    ),
                                                    const Color(
                                                      0xFF0A4A8E,
                                                    ).withAlpha(
                                                      (0.1 * 255).round(),
                                                    ),
                                                  ],
                                                )
                                              : null,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          icons[index],
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white.withAlpha(
                                                  (0.8 * 255).round(),
                                                ),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          labels[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white.withAlpha(
                                                    (0.85 * 255).round(),
                                                  ),
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
                                            ).withAlpha((0.8 * 255).round()),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF0A4A8E)
                                                    .withAlpha(
                                                      (0.5 * 255).round(),
                                                    ),
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
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),

              // Bottom Section
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Contact Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Builder(
                        builder: (context) => AnimatedNavigateButton(
                          borderRadius: 16,
                          label: "Send Me a Message",
                          onTap: () async {
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            if (context.mounted) {
                              showBlurredGeneralDialog(
                                context: context,
                                builder: (context) => const ContactMeView(),
                              );
                            }
                          },
                          icon: Image.asset(
                            'assets/icons/contact_me.png',
                            width: 28,
                            height: 28,
                            fit: BoxFit.fitHeight,
                          ),
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  Divider(
                    height: 1,
                    color: const Color(
                      0xFF0A4A8E,
                    ).withAlpha((0.3 * 255).round()),
                  ),

                  // Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FooterWidgets.ccLabel(
                      Colors.white.withAlpha((0.7 * 255).round()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
