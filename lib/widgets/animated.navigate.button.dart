import 'package:flutter/material.dart';

class AnimatedNavigateButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Widget? icon;
  final Color? color;
  final Color? hoverColor;
  final double? width;
  final double? height;
  final bool? isHovered;
  final bool? reset;
  final double? borderRadius;

  const AnimatedNavigateButton({
    super.key,
    this.reset = false,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.hoverColor,
    this.width,
    this.height = 48,
    this.isHovered,
    this.borderRadius,
  });

  @override
  State<AnimatedNavigateButton> createState() => _AnimatedNavigateButtonState();
}

class _AnimatedNavigateButtonState extends State<AnimatedNavigateButton> {
  bool _isHovered = false;
  final GlobalKey _containerKey = GlobalKey();
  Offset _offset = Offset.zero;
  Offset _center = Offset.zero;

  void _updateOffset(PointerEvent details) {
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
    final Color borderColor = Color.lerp(Colors.white, Colors.black, 0.5)!;
    final bool isHovered = widget.isHovered ?? _isHovered;
    return MouseRegion(
      onEnter: (_) {
        if (widget.isHovered != null) {
          debugPrint("Mouse Entered");
        } else {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (widget.isHovered != null) {
          debugPrint("Mouse Exited");
        } else {
          setState(() => _isHovered = false);
        }
        if (widget.reset == true) {
          _resetOffset();
        }
      },
      onHover: _updateOffset,
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: isHovered ? 0.94 : 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: AnimatedAlign(
            alignment: Alignment(
              (_offset.dx / ((widget.width ?? 120) / 2)).clamp(-1.0, 1.0),
              (_offset.dy / ((widget.height ?? 48) / 2)).clamp(-1.0, 1.0),
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: Container(
              key: _containerKey,
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Color.lerp(Colors.black, Colors.transparent, 0.9),
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? widget.height! / 2,
                ),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: widget.onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 16),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontFamily: 'ShantellSans',
                      ),
                    ),
                    Spacer(),
                    widget.icon ?? const SizedBox(),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:portfolio/infrastructure/theme/colors.dart';
//
// class AnimatedNavigateButton extends StatefulWidget {
//   final String label;
//   final VoidCallback onTap;
//   final Widget? icon;
//   final Color? color;
//   final Color? hoverColor;
//   final double? width;
//   final double? height;
//   final bool? isHovered;
//   final double? borderRadius;
//
//   const AnimatedNavigateButton({
//     super.key,
//     required this.label,
//     required this.onTap,
//     this.icon,
//     this.color,
//     this.hoverColor,
//     this.width,
//     this.height = 48,
//     this.isHovered,
//     this.borderRadius,
//   });
//
//   @override
//   State<AnimatedNavigateButton> createState() => _AnimatedNavigateButtonState();
// }
//
// class _AnimatedNavigateButtonState extends State<AnimatedNavigateButton> {
//   bool _isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final Color borderColor = Color.lerp(Colors.white, Colors.black, 0.5)!;
//     final Color backgroundColor = Colors.transparent;
//     final bool isHovered = widget.isHovered ?? _isHovered;
//     return MouseRegion(
//       onEnter: (_) {
//         if (widget.isHovered != null) {
//           debugPrint("Mouse Entered");
//         } else {
//           setState(() => _isHovered = true);
//         }
//       },
//       onExit: (_) {
//         if (widget.isHovered != null) {
//           debugPrint("Mouse Exited");
//         } else {
//           setState(() => _isHovered = false);
//         }
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeInOut,
//         width: (widget.width! - 10) + (isHovered ? 10 : 0),
//         height: widget.height,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(
//             widget.borderRadius ?? widget.height! / 2,
//           ),
//           border: Border.all(color: borderColor, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: KColor.secondarySecondColor,
//               blurRadius: 0,
//               offset: isHovered ? const Offset(0, 0) : const Offset(-5, 5),
//             ),
//           ],
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(24),
//           onTap: widget.onTap,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(width: 16),
//               Text(
//                 widget.label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.normal,
//                   fontSize: 16,
//                   fontFamily: 'ShantellSans',
//                 ),
//               ),
//               Spacer(),
//               widget.icon ?? const SizedBox(),
//               SizedBox(width: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
