import 'package:flutter/material.dart';

typedef DialogBuilder = Widget Function(BuildContext context);

dynamic showBlurredGeneralDialog({
  required BuildContext context,
  required DialogBuilder builder,
  String barrierLabel = 'Dialog',
  Color barrierColor = const Color(0x66000000),
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: barrierLabel,
    barrierColor: Colors.black.withAlpha((255 * 0.5).toInt()),
    transitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, anim1, anim2) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {}, // Prevents pop when tapping the child
          child: builder(context),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final animation = CurvedAnimation(parent: anim1, curve: Curves.easeInOut);
      return RepaintBoundary(
        child: FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
      );
    },
  );
}
