import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/infrastructure/theme/colors.dart';
import '../controllers/home.controller.dart';

class HomeFloatingMenuBar extends GetView<HomeController> {
  HomeFloatingMenuBar({super.key});

  final List<String> labels = ['Home', 'About Me', 'Works', 'Certificates'];

  @override
  Widget build(BuildContext context) {
    const double barHeight = 60;
    const double tabWidth = 160;

    return Container(
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      height: barHeight,
      decoration: BoxDecoration(
        color: Color.lerp(KColor.darkSlate, Colors.transparent, 0.2),
        // Brighter than 0xFF16213E
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final selectedIndex = controller.selectedTabIndex.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Animated pill background for the selected tab
            AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              left: tabWidth * selectedIndex,
              width: tabWidth,
              height: barHeight,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    Colors.deepPurpleAccent,
                    Colors.transparent,
                    0.4,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Tab buttons
            Row(
              children: List.generate(labels.length, (index) {
                final isSelected = selectedIndex == index;
                return Container(
                  alignment: Alignment.center,
                  width: tabWidth,
                  height: barHeight,
                  child: _StackAnimatedTextTabButton(
                    label: labels[index],
                    isSelected: isSelected,
                    onTap: controller.onTapActions[index],
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

class _StackAnimatedTextTabButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StackAnimatedTextTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_StackAnimatedTextTabButton> createState() =>
      _StackAnimatedTextTabButtonState();
}

class _StackAnimatedTextTabButtonState
    extends State<_StackAnimatedTextTabButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bool showOrange = widget.isSelected || _hover;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        child: Container(
          width: 135,
          height: 60,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base text (black)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                top: showOrange ? -44 : 0,
                left: 0,
                right: 0,
                height: 60,
                // Force height to match parent
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 450),
                  opacity: showOrange ? 0.0 : 1.0,
                  child: Center(
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: "ShantellSans",
                      ),
                    ),
                  ),
                ),
              ),
              // Orange text (slides in from below and fades in)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                top: showOrange ? 0 : 44,
                left: 0,
                right: 0,
                height: 60,
                // Force height to match parent
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: showOrange ? 1.0 : 0.0,
                  child: Center(
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontFamily: "ShantellSans",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
