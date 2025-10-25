import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import '../../infrastructure/theme/colors.dart';
import '../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';

class KPrettyAnimated extends StatefulWidget {
  const KPrettyAnimated({super.key});

  @override
  State<KPrettyAnimated> createState() => _KPrettyAnimatedState();
}

class _KPrettyAnimatedState extends State<KPrettyAnimated> {
  final List<String> _words = [
    "A passionate Flutter developer.",
    "Building beautiful, performant apps.",
    "Java & Spring enthusiast.",
    "Coffee-powered coder ☕",
    "Always learning, always building.",
    "Code. Create. Inspire.",
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _currentIndex = 0;
      });
      _runAnimationLoop();
    });
  }

  void _runAnimationLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 6));
      if (!mounted) break;
      setState(() {
        if (_currentIndex < _words.length - 1) {
          _currentIndex += 1;
        } else {
          _currentIndex = 0;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  double _getResponsiveFontSize(double screenWidth) {
    // Define breakpoints and font sizes
    const double minWidth = 320.0; // Mobile min width
    const double maxWidth = 1920.0; // Desktop max width

    const double minFontSize = 24.0; // Font size at minWidth
    const double maxFontSize = 90.0; // Font size at maxWidth

    // Clamp the screen width between min and max
    final clampedWidth = screenWidth.clamp(minWidth, maxWidth);

    // Calculate the lerp factor (0.0 to 1.0)
    final t = (clampedWidth - minWidth) / (maxWidth - minWidth);

    // Lerp between min and max font size
    return minFontSize + (maxFontSize - minFontSize) * t;
  }

  @override
  Widget build(BuildContext context) {
    Get.find<InfoFetchController>();

    // Get screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font size based on width
    final double fontSize = _getResponsiveFontSize(screenWidth);

    if (!mounted) {
      return const SizedBox.shrink();
    }

    return KeyedSubtree(
      key: ValueKey(_currentIndex),
      child: OffsetText(
        text: _words[_currentIndex],
        duration: const Duration(seconds: 2),
        type: AnimationType.word,
        slideType: SlideAnimationType.rightLeft,
        textStyle: TextStyle(
          wordSpacing: 10,
          fontSize: fontSize,
          fontFamily: 'ShantellSans',
          color: KColor.secondarySecondColor,
          shadows: [Shadow(color: Colors.pinkAccent, blurRadius: 2)],
        ),
      ),
    );
  }
}
