import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/configs/constant_strings.dart';

import '../../../domain/models/tools_model/tools.model.dart';

class AnimatedToolsWidget extends StatefulWidget {
  final List<ToolsModel> tools;
  final Duration duration;

  const AnimatedToolsWidget({
    super.key,
    required this.tools,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedToolsWidget> createState() => _AnimatedToolsWidgetState();
}

class _AnimatedToolsWidgetState extends State<AnimatedToolsWidget>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _nextIndex = 0;
  bool _showNext = false;
  Timer? _timer;

  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _alignmentAnim = Tween<Alignment>(
      begin: Alignment.center,
      end: Alignment(0, -4),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnim = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _timer = Timer.periodic(widget.duration, (_) {
      setState(() {
        _nextIndex = (_currentIndex + 1) % widget.tools.length;
        _showNext = false;
      });
      _controller.forward(from: 0).then((_) {
        setState(() {
          _currentIndex = _nextIndex;
          _showNext = true;
        });
        _controller.reverse(from: 1.0);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    final tool = widget.tools[_currentIndex];
    final color = Color(int.parse(tool.color));
    TextStyle textStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color.lerp(color, Colors.white, 0.3),
    );
    final textWidth = _calculateTextWidth(tool.name, textStyle);
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.centerLeft,
      children: [
        ClipPath(
          clipper: _LeftCircleClipper(),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: 42,
            width: textWidth + 80,
            margin: EdgeInsets.only(left: 36),
            padding: EdgeInsets.only(left: 40, right: 10),
            decoration: BoxDecoration(
              color: Color.lerp(color, Colors.transparent, 0.3),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  if (!_showNext) {
                    return Align(
                      alignment: Alignment.lerp(
                        Alignment(0, 1),
                        Alignment.center,
                        1 - _controller.value,
                      )!,
                      child: Opacity(
                        opacity: _opacityAnim.value,
                        child: Text(
                          tool.name,
                          style: textStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    );
                  } else {
                    return Align(
                      alignment: _alignmentAnim.value,
                      child: Opacity(
                        opacity: 1 - _controller.value,
                        child: Text(
                          tool.name,
                          style: textStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          clipBehavior: Clip.hardEdge,
          height: 72,
          width: 72,
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.lerp(color, Colors.transparent, 0.3),
            shape: BoxShape.circle,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (!_showNext) {
                return Align(
                  alignment: _alignmentAnim.value,
                  child: Opacity(
                    opacity: _opacityAnim.value,
                    child: SvgPicture.network(
                      assetGithubUrl + tool.image,
                      width: 48,
                      height: 48,
                      placeholderBuilder: (context) => const SizedBox.shrink(),
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              } else {
                return Align(
                  alignment: Alignment.lerp(
                    Alignment(0, 1),
                    Alignment.center,
                    1 - _controller.value,
                  )!,
                  child: Opacity(
                    opacity: 1 - _controller.value,
                    child: SvgPicture.network(
                      assetGithubUrl + tool.image,
                      width: 48,
                      height: 48,
                      placeholderBuilder: (context) => const SizedBox.shrink(),
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _LeftCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double radius = 35.9; // slightly larger than the avatar
    final path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(radius, size.height);
    path.arcTo(
      Rect.fromCircle(center: Offset(36, size.height / 2), radius: radius),
      0.6 * 3.141592653589793, // Start at 180 degrees (left middle)
      -3.141592653589793, // Sweep a full 180 degrees (down to up)
      false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class AnimatedTextReveal extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const AnimatedTextReveal({
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 400),
    super.key,
  });

  @override
  State<AnimatedTextReveal> createState() => _AnimatedTextRevealState();
}

class _AnimatedTextRevealState extends State<AnimatedTextReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _charCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedTextReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.reset();
      _charCount = StepTween(
        begin: 0,
        end: widget.text.length,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, child) {
        String visibleText = widget.text.substring(0, _charCount.value);
        return Text(
          visibleText,
          style: widget.style,
          textAlign: TextAlign.left,
        );
      },
    );
  }
}
