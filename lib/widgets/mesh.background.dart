import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:portfolio/infrastructure/theme/colors.dart';

class SharedMeshBackground extends StatefulWidget {
  const SharedMeshBackground({super.key, this.mouseOffset = Offset.zero});

  /// Normalised mouse offset in -1..1 on both axes (0,0 = center).
  final Offset mouseOffset;

  @override
  State<SharedMeshBackground> createState() => _SharedMeshBackgroundState();
}

class _SharedMeshBackgroundState extends State<SharedMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimatedMeshGradientController _controller;

  // Smoothly interpolate toward the target mouse offset
  late AnimationController _tiltAnim;
  Offset _currentTilt = Offset.zero;
  Offset _targetTilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimatedMeshGradientController()..start();
    _tiltAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // drives ticker only
    )..repeat();
    _tiltAnim.addListener(_smoothTilt);
  }

  void _smoothTilt() {
    final next = widget.mouseOffset;
    if (next != _targetTilt) _targetTilt = next;
    // Lerp: ~8% per frame → smooth lag
    final dx = _currentTilt.dx + (_targetTilt.dx - _currentTilt.dx) * 0.03;
    final dy = _currentTilt.dy + (_targetTilt.dy - _currentTilt.dy) * 0.03;
    if ((dx - _currentTilt.dx).abs() > 0.0001 ||
        (dy - _currentTilt.dy).abs() > 0.0001) {
      setState(() => _currentTilt = Offset(dx, dy));
    }
  }

  @override
  void dispose() {
    _tiltAnim.removeListener(_smoothTilt);
    _tiltAnim.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Mesh gradient background
            Positioned.fill(
              child: AnimatedMeshGradient(
                colors: const [
                  KColor.meshDark1,
                  KColor.meshDark2,
                  KColor.meshDark3,
                  KColor.meshDark4,
                ],
                controller: _controller,
                options: AnimatedMeshGradientOptions(
                  speed: 0.2,
                  frequency: 1.5,
                  amplitude: 1.2,
                  grain: 0.0,
                ),
              ),
            ),
            // Tech grid overlay
            Positioned.fill(
              child: CustomPaint(
                painter: _TechGridPainter(tilt: _currentTilt),
                size: Size.infinite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechGridPainter extends CustomPainter {
  const _TechGridPainter({this.tilt = Offset.zero});

  final Offset tilt; // -1..1 on both axes, (0,0) = center

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Vanishing point (cursor center) — shifts subtly ─────────────────
    final vpx = w / 2 + tilt.dx * w * 0.08;
    final vpy = h / 2 + tilt.dy * h * 0.08;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.5;

    // ── Grid shift: move parabolas slightly in cursor direction ────────
    // tilt is -1..1; shift lines by a fraction of screen size
    final gridShiftX = tilt.dx * w * 0.06;
    final gridShiftY = tilt.dy * h * 0.06;

    // ── 1. VERTICAL PARABOLIC LINES ─────────────────────────────────────
    // Each vertical line runs from y=0 to y=h (full height).
    // At the VP's y-level the line sits at its base x-position.
    // As y moves away from vpy, the line bows outward (away from vpx)
    // following a parabola: x = baseX + bow * (normalised_distance²).
    //
    // Lines on the LEFT of vpx bow further left.
    // Lines on the RIGHT of vpx bow further right.
    const vCount = 8; // lines per side
    for (int side = -1; side <= 1; side += 2) {
      for (int i = 1; i <= vCount; i++) {
        // Normalised 0..1 where 0 = at VP, 1 = at edge
        final n = i / (vCount + 1);

        // Base x: evenly spaced between vpx and the edge
        final edgeDist = side == 1 ? (w - vpx) : vpx;
        final baseX = vpx + side * n * edgeDist + gridShiftX;

        // Bow strength: lines further from center bow more (quadratic)
        final bow = side * n * n * edgeDist * 0.55;

        final alpha = _alphaForDist(n);

        _drawVerticalParabola(
          canvas,
          w,
          h,
          vpx,
          vpy,
          baseX,
          bow,
          alpha,
          linePaint,
        );
      }
    }

    // ── 2. HORIZONTAL PARABOLIC LINES ───────────────────────────────────
    // Same idea but rotated 90°: each line runs from x=0 to x=w.
    // At the VP's x-level the line sits at its base y-position.
    // As x moves away from vpx, the line bows outward (away from vpy).
    const hCount = 6; // lines per side
    for (int side = -1; side <= 1; side += 2) {
      for (int i = 1; i <= hCount; i++) {
        final n = i / (hCount + 1);

        final edgeDist = side == 1 ? (h - vpy) : vpy;
        final baseY = vpy + side * n * edgeDist + gridShiftY;

        final bow = side * n * n * edgeDist * 0.55;

        final alpha = _alphaForDist(n);

        _drawHorizontalParabola(
          canvas,
          w,
          h,
          vpx,
          vpy,
          baseY,
          bow,
          alpha,
          linePaint,
        );
      }
    }

    // ── 3. CENTER GLOW ──────────────────────────────────────────────────
    // final vp = Offset(vpx, vpy);
    // for (final (r, a) in [
    //   (28.0, 0.03),
    //   (10.0, 0.06),
    //   (3.5, 0.18),
    //   (1.2, 0.55),
    // ]) {
    //   canvas.drawCircle(
    //     vp,
    //     r,
    //     Paint()
    //       ..style = PaintingStyle.fill
    //       ..color = KColor.meshGlow.withValues(alpha: a)
    //       ..maskFilter = r > 5
    //           ? const MaskFilter.blur(BlurStyle.normal, 8)
    //           : null,
    //   );
    // }
  }

  // ── Vertical parabola (full height, bows on x-axis) ──────────────────
  void _drawVerticalParabola(
    Canvas canvas,
    double w,
    double h,
    double vpx,
    double vpy,
    double baseX,
    double bow,
    double alpha,
    Paint p,
  ) {
    final path = Path();
    const steps = 64;
    for (int s = 0; s <= steps; s++) {
      final t = s / steps;
      final y = t * h;
      // u = normalised distance from VP on the y-axis, -1..1
      final u = (y - vpy) / (h / 2);
      // Parabola: offset = bow * u²  (maximum bow at top/bottom edges)
      final x = baseX + bow * u * u;
      s == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    p
      ..color = KColor.meshGlow.withValues(alpha: alpha)
      ..strokeWidth = 0.5;
    canvas.drawPath(path, p);
  }

  // ── Horizontal parabola (full width, bows on y-axis) ─────────────────
  void _drawHorizontalParabola(
    Canvas canvas,
    double w,
    double h,
    double vpx,
    double vpy,
    double baseY,
    double bow,
    double alpha,
    Paint p,
  ) {
    final path = Path();
    const steps = 64;
    for (int s = 0; s <= steps; s++) {
      final t = s / steps;
      final x = t * w;
      // u = normalised distance from VP on the x-axis, -1..1
      final u = (x - vpx) / (w / 2);
      // Parabola: offset = bow * u²
      final y = baseY + bow * u * u;
      s == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    p
      ..color = KColor.meshGlow.withValues(alpha: alpha)
      ..strokeWidth = 0.5;
    canvas.drawPath(path, p);
  }

  /// Closer to center → more transparent; further → slightly brighter.
  double _alphaForDist(double n) => (0.03 + 0.09 * n).clamp(0.0, 1.0);

  @override
  bool shouldRepaint(_TechGridPainter old) => old.tilt != tilt;
}
