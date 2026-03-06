import 'package:portfolio/infrastructure/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../../utils/launch.url.dart';

class AnimatedRotateIcon extends StatefulWidget {
  final Widget firstIcon;
  final Widget secondIcon;
  final String label;
  final String url;

  const AnimatedRotateIcon({
    super.key,
    required this.firstIcon,
    required this.secondIcon,
    required this.label,
    required this.url,
  });

  @override
  State<AnimatedRotateIcon> createState() => _AnimatedRotateIconState();
}

class _AnimatedRotateIconState extends State<AnimatedRotateIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          launchUrlExternal(widget.url);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40, // Adjust as needed for icon size
              width: 40, // Adjust as needed for icon size
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    top: _isHovered ? -40 : 0,
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 600),
                      child: widget.firstIcon,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: _isHovered ? 0 : 40,
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: widget.secondIcon,
                    ),
                  ),
                ],
              ),
            ),
            widget.label.isEmpty
                ? const SizedBox.shrink()
                : const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: KColor.secondarySecondColor,
                fontFamily: "ShantellSans",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
