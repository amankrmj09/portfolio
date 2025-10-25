import 'package:flutter/material.dart';

import '../../../infrastructure/theme/colors.dart';

class InfiniteTiltedStrip extends StatefulWidget {
  final List<StripItem> items;
  final double speed;
  final double height;

  const InfiniteTiltedStrip({
    super.key,
    required this.items,
    this.speed = 20.0,
    this.height = 50.0,
  });

  @override
  State<InfiniteTiltedStrip> createState() => _InfiniteTiltedStripState();
}

class _InfiniteTiltedStripState extends State<InfiniteTiltedStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final ScrollController _scrollController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 365), // Effectively infinite
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addListener(_scrollListener);
      _controller.repeat();
    });
  }

  void _scrollListener() {
    if (_isHovered) return;
    if (!_scrollController.hasClients ||
        !_scrollController.position.hasContentDimensions ||
        !_scrollController.position.hasPixels) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (!(maxScroll > 0) || !maxScroll.isFinite) return;
    final current = _scrollController.offset;
    final next = current + widget.speed * 0.016; // 60fps
    if (next >= maxScroll) {
      _scrollController.jumpTo(0);
    } else {
      _scrollController.jumpTo(next);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repeatedItems = List.generate(
      7,
      (_) => widget.items,
    ).expand((e) => e).toList();
    // The hit test area must match the rotated area. Use Transform.rotate on both MouseRegion and content.
    // The only way to get a truly matching hit area is to use a custom gesture detector or pointer region.
    // As a workaround, make the MouseRegion hit area larger and visually match the rotated strip.
    // This will not be pixel-perfect, but will be much closer.
    return Container(
      color: KColor.secondarySecondColor,
      height: widget.height * 2,
      // Make the container tall enough for the rotated strip
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(0.5),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          height: widget.height,
          color: Colors.transparent,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: repeatedItems.length,
            itemBuilder: (context, index) {
              final item = repeatedItems[index % widget.items.length];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    item.icon,
                    const SizedBox(width: 8),
                    Text(
                      item.text,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KColor.primaryColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class StripItem {
  final Widget icon;
  final String text;

  const StripItem({required this.icon, required this.text});
}
