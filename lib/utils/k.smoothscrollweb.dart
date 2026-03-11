import 'package:flutter/material.dart';
import 'package:flutter_web_scroll/flutter_web_scroll.dart';

class KSmoothScrollWeb extends StatefulWidget {
  /// The scrollable child widget (e.g. ListView, SingleChildScrollView).
  final Widget child;

  /// An optional external [ScrollController].
  /// If not provided, an internal one will be created and managed automatically.
  final ScrollController? controller;

  const KSmoothScrollWeb({super.key, required this.child, this.controller});

  @override
  State<KSmoothScrollWeb> createState() => _KSmoothScrollWebState();
}

class _KSmoothScrollWebState extends State<KSmoothScrollWeb> {
  late final ScrollController _internalController;
  late final bool _ownsController;

  ScrollController get _controller => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    if (_ownsController) {
      _internalController = ScrollController();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmoothScrollWeb(
      controller: _controller,
      config: SmoothScrollConfig.lenis(
        scrollSpeed: 1.2, // Distance multiplier
        damping: 0.04, // Lower = smoother/heavier
        enableMomentum: true, // Enable throw scrolling
        momentumFactor: 0.5, // Throw distance factor
      ),
      child: widget.child,
    );
  }
}
