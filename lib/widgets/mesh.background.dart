import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:portfolio/infrastructure/theme/colors.dart';

class SharedMeshBackground extends StatefulWidget {
  const SharedMeshBackground({super.key, this.mouseOffset});

  /// Normalised mouse offset in -1..1 on both axes (0,0 = center).
  /// When null the grid stays centered.
  final Offset? mouseOffset;

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
    final next = widget.mouseOffset ?? Offset.zero;
    if (next != _targetTilt) _targetTilt = next;
    // Lerp: ~8% per frame → smooth lag
    final dx = _currentTilt.dx + (_targetTilt.dx - _currentTilt.dx) * 0.06;
    final dy = _currentTilt.dy + (_targetTilt.dy - _currentTilt.dy) * 0.06;
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

  final Offset tilt;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // VP shifts with mouse — everything is relative to VP, not cx/cy
    final vpx = cx + tilt.dx * cx * 0.3;
    final vpy = cy + tilt.dy * cy * 0.3;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.5;

    // ── 1. PARABOLIC VERTICAL LINES ──────────────────────────────────────────
    // Edges are placed relative to vpx so they fan out from the shifted VP
    const vLineCount = 7;
    for (int i = 1; i <= vLineCount; i++) {
      final n = (i / (vLineCount + 1)) * (i / (vLineCount + 1));

      // Right side: from vpx → right edge, left side: from vpx → left edge
      final edgeX_right = vpx + n * (size.width - vpx);
      final edgeX_left = vpx - n * vpx;

      // Bow pulls inward toward vpx
      final bow_right = (edgeX_right - vpx) * n * 0.45;
      final bow_left = (vpx - edgeX_left) * n * 0.45;

      _drawParabolicVLine(
        canvas,
        size,
        vpy,
        edgeX_right,
        -bow_right,
        _lineAlpha(n),
        linePaint,
      );
      _drawParabolicVLine(
        canvas,
        size,
        vpy,
        edgeX_left,
        bow_left,
        _lineAlpha(n),
        linePaint,
      );
    }

    // ── 2. PARABOLIC HORIZONTAL LINES ────────────────────────────────────────
    // Edges are placed relative to vpy so they fan out from the shifted VP
    const hLineCount = 5;
    for (int i = 1; i <= hLineCount; i++) {
      final n = (i / (hLineCount + 1)) * (i / (hLineCount + 1));

      // Bottom side: from vpy → bottom edge, top side: from vpy → top edge
      final edgeY_bottom = vpy + n * (size.height - vpy);
      final edgeY_top = vpy - n * vpy;

      // Bow pulls inward toward vpy
      final bow_bottom = (edgeY_bottom - vpy) * n * 0.40;
      final bow_top = (vpy - edgeY_top) * n * 0.40;

      _drawParabolicHLine(
        canvas,
        size,
        vpx,
        edgeY_bottom,
        -bow_bottom,
        _lineAlpha(n),
        linePaint,
      );
      _drawParabolicHLine(
        canvas,
        size,
        vpx,
        edgeY_top,
        bow_top,
        _lineAlpha(n),
        linePaint,
      );
    }

    // ── 3. CENTER GLOW at VP ─────────────────────────────────────────────────
    final vp = Offset(vpx, vpy);
    for (final (r, a) in [
      (28.0, 0.03),
      (10.0, 0.06),
      (3.5, 0.18),
      (1.2, 0.55),
    ]) {
      canvas.drawCircle(
        vp,
        r,
        Paint()
          ..style = PaintingStyle.fill
          ..color = KColor.meshGlow.withValues(alpha: a)
          ..maskFilter = r > 5
              ? const MaskFilter.blur(BlurStyle.normal, 8)
              : null,
      );
    }
  }

  void _drawParabolicVLine(
    Canvas canvas,
    Size size,
    double vpY,
    double edgeX,
    double bow,
    double alpha,
    Paint p,
  ) {
    final path = Path();
    const steps = 60;
    for (int s = 0; s <= steps; s++) {
      final t = s / steps;
      final y = t * size.height;
      final u = (y - vpY) / (size.height / 2);
      final x = edgeX + bow * (1 - u * u);
      s == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    p
      ..color = KColor.meshGlow.withValues(alpha: alpha)
      ..strokeWidth = 0.5;
    canvas.drawPath(path, p);
  }

  void _drawParabolicHLine(
    Canvas canvas,
    Size size,
    double vpX,
    double edgeY,
    double bow,
    double alpha,
    Paint p,
  ) {
    final path = Path();
    const steps = 60;
    for (int s = 0; s <= steps; s++) {
      final t = s / steps;
      final x = t * size.width;
      final u = (x - vpX) / (size.width / 2);
      final y = edgeY + bow * (1 - u * u);
      s == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    p
      ..color = KColor.meshGlow.withValues(alpha: alpha)
      ..strokeWidth = 0.5;
    canvas.drawPath(path, p);
  }

  double _lineAlpha(double n) => (0.04 + 0.10 * n).clamp(0.0, 1.0);

  @override
  bool shouldRepaint(_TechGridPainter old) => old.tilt != tilt;
}
