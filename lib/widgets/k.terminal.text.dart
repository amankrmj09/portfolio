import 'package:flutter/material.dart';

/// A terminal-style text widget with a blinking cursor appended at the end.
///
/// Usage:
/// ```dart
/// KTerminalText(text: '~/portfolio')
/// ```
class KTerminalText extends StatefulWidget {
  const KTerminalText({
    super.key,
    this.text = '~/portfolio',
    this.fontSize = 13,
    this.textColor = const Color(0xFF00FF88),
    this.cursorColor = const Color(0xFF00FF88),
    this.cursorWidth = 8.0,
    this.cursorHeight = 16.0,
    this.blinkDuration = const Duration(milliseconds: 600),
  });

  final String text;
  final double fontSize;
  final Color textColor;
  final Color cursorColor;
  final double cursorWidth;
  final double cursorHeight;
  final Duration blinkDuration;

  @override
  State<KTerminalText> createState() => _KTerminalTextState();
}

class _KTerminalTextState extends State<KTerminalText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.blinkDuration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor,
            fontSize: widget.fontSize,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 4),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Opacity(
              opacity: _controller.value,
              child: Container(
                width: widget.cursorWidth,
                height: widget.cursorHeight,
                color: widget.cursorColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
