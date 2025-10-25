import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/configs/constant_strings.dart';
import 'package:portfolio/domain/models/export.models.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileWidget extends StatefulWidget {
  final ProfileLinksModel profile;
  final bool? reset;
  final bool disableHover; // ✅ New parameter

  const ProfileWidget({
    super.key,
    required this.profile,
    this.reset = false,
    this.disableHover = false, // ✅ Default false
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool _isHovered = false;
  final GlobalKey _containerKey = GlobalKey();
  Offset _offset = Offset.zero;
  Offset _center = Offset.zero;

  void _updateOffset(PointerEvent details) {
    if (widget.disableHover) return; // ✅ Skip on mobile

    final RenderBox? box =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      setState(() {
        _center = position + Offset(size.width / 2, size.height / 2);
        _offset = details.position - _center;
      });
    }
  }

  void _resetOffset() {
    setState(() {
      _offset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(widget.profile.color1));
    TextStyle textStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color.lerp(color, Colors.white, 0.3),
    );
    final textWidth = _calculateTextWidth(widget.profile.name, textStyle);

    return InkWell(
      onTap: () => launchUrlString(widget.profile.url),
      child: SizedBox(
        width: textWidth + 80 + 72 + 20,
        height: 72 + 40,
        child: MouseRegion(
          onEnter: widget.disableHover
              ? null // ✅ Disable hover on mobile
              : (_) => setState(() => _isHovered = true),
          onExit: widget.disableHover
              ? null // ✅ Disable hover on mobile
              : (_) {
                  setState(() => _isHovered = false);
                  if (widget.reset == true) {
                    _resetOffset();
                  }
                },
          onHover: widget.disableHover ? null : _updateOffset,
          // ✅ Disable hover on mobile
          cursor: SystemMouseCursors.click,
          child: TweenAnimationBuilder(
            tween: Tween<double>(
              begin: 1.0,
              end: (widget.disableHover || !_isHovered)
                  ? 1.0
                  : 0.94, // ✅ No scale on mobile
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: AnimatedAlign(
                alignment: widget.disableHover
                    ? Alignment
                          .center // ✅ Fixed alignment on mobile
                    : Alignment(
                        (_offset.dx / ((textWidth + 80 + 72 + 20) / 2)).clamp(
                          -1.0,
                          1.0,
                        ),
                        (_offset.dy / ((72 + 20) / 2)).clamp(-1.0, 1.0),
                      ),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.centerLeft,
                  children: [
                    ClipPath(
                      clipper: _LeftCircleClipper(),
                      child: Container(
                        height: 42,
                        width: textWidth + 80,
                        margin: const EdgeInsets.only(left: 36),
                        padding: const EdgeInsets.only(left: 40, right: 10),
                        decoration: BoxDecoration(
                          color: Color.lerp(color, Colors.transparent, 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.profile.name,
                          style: textStyle,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Container(
                      key: _containerKey,
                      clipBehavior: Clip.hardEdge,
                      height: 72,
                      width: 72,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color.lerp(color, Colors.transparent, 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.network(
                        assetGithubUrl + widget.profile.icon,
                        width: 48,
                        height: 48,
                        placeholderBuilder: (context) =>
                            const SizedBox.shrink(),
                        // ignore: deprecated_member_use
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
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
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }
}

class _LeftCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double radius = 35.9;
    final path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(radius, size.height);
    path.arcTo(
      Rect.fromCircle(center: Offset(36, size.height / 2), radius: radius),
      0.6 * 3.141592653589793,
      -3.141592653589793,
      false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
