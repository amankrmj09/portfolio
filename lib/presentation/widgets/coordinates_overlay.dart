import 'package:flutter/material.dart';
import 'dart:math' as math;

const _kGreen = Color(0xFF00FF88);
const _kDimGreen = Color(0x4400FF88);
const _kBg = Color(0xCC000D1A);

class CoordinatesOverlay extends StatelessWidget {
  const CoordinatesOverlay({
    super.key,
    required this.position,
    required this.devicePixelRatio,
    required this.containerHeight,
    required this.containerWidth,
  });

  final Offset position;
  final double devicePixelRatio;
  final double containerHeight;
  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: _CoordinatesOverlayContent(
        position: position,
        devicePixelRatio: devicePixelRatio,
        containerHeight: containerHeight,
        containerWidth: containerWidth,
      ),
    );
  }
}

class _CoordinatesOverlayContent extends StatefulWidget {
  const _CoordinatesOverlayContent({
    required this.position,
    required this.devicePixelRatio,
    required this.containerHeight,
    required this.containerWidth,
  });

  final Offset position;
  final double devicePixelRatio;
  final double containerHeight;
  final double containerWidth;

  @override
  State<_CoordinatesOverlayContent> createState() =>
      _CoordinatesOverlayContentState();
}

class _CoordinatesOverlayContentState extends State<_CoordinatesOverlayContent>
    with TickerProviderStateMixin {
  late AnimationController _blink;
  late AnimationController _scan;

  @override
  void initState() {
    super.initState();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _blink.dispose();
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cx = widget.containerWidth / 2;
    final cy = widget.containerHeight / 2;
    final dpr = widget.devicePixelRatio;

    // (0,0) = center   +X = right   +Y = up
    final x = ((widget.position.dx - cx) * dpr).round();
    final y = (-(widget.position.dy - cy) * dpr).round();

    // Angle from center: 0° = right, 90° = up, CCW positive
    final angle =
        math.atan2(-(widget.position.dy - cy), (widget.position.dx - cx)) *
        180 /
        math.pi;

    // Sign labels for readability
    final xLabel = x >= 0 ? '+$x' : '$x';
    final yLabel = y >= 0 ? '+$y' : '$y';

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _scan,
            builder: (_, __) =>
                CustomPaint(painter: _FramePainter(scanProgress: _scan.value)),
          ),
        ),
        Container(
          width: 190,
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          decoration: BoxDecoration(
            color: _kBg,
            border: Border.all(color: _kDimGreen, width: 0.6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _blink,
                    builder: (_, __) => Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _kGreen.withValues(alpha: _blink.value),
                        boxShadow: [
                          BoxShadow(
                            color: _kGreen.withValues(
                              alpha: _blink.value * 0.8,
                            ),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'NAV  LOCK',
                    style: TextStyle(
                      color: _kGreen.withValues(alpha: 0.45),
                      fontSize: 8,
                      fontFamily: 'monospace',
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(height: 0.5, color: _kDimGreen),
              const SizedBox(height: 7),
              _AxisRow(label: 'X', value: xLabel),
              const SizedBox(height: 4),
              _AxisRow(label: 'Y', value: yLabel),
              const SizedBox(height: 6),
              Container(height: 0.5, color: _kDimGreen),
              const SizedBox(height: 5),
              Text(
                '∠  ${angle.toStringAsFixed(1)}°',
                style: TextStyle(
                  color: _kGreen.withValues(alpha: 0.35),
                  fontSize: 8,
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Axis Row ─────────────────────────────────────────────────────────────────
class _AxisRow extends StatelessWidget {
  const _AxisRow({required this.label, required this.value});

  final String label;
  final String value; // signed string e.g. "+0342" or "-0123"

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: _kGreen.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: _kGreen.withValues(alpha: 0.6),
              fontSize: 8,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            color: _kGreen,
            fontSize: 13,
            fontFamily: 'monospace',
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(color: _kGreen.withValues(alpha: 0.55), blurRadius: 7),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'px',
          style: TextStyle(
            color: _kGreen.withValues(alpha: 0.25),
            fontSize: 8,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

// ─── Frame + Scanline Painter ─────────────────────────────────────────────────
class _FramePainter extends CustomPainter {
  const _FramePainter({required this.scanProgress});

  final double scanProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final bracketPaint = Paint()
      ..color = _kGreen
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const len = 10.0;

    _corner(canvas, Offset.zero, bracketPaint, 1, 1, len);
    _corner(canvas, Offset(size.width, 0), bracketPaint, -1, 1, len);
    _corner(canvas, Offset(0, size.height), bracketPaint, 1, -1, len);
    _corner(canvas, Offset(size.width, size.height), bracketPaint, -1, -1, len);

    final scanY = size.height * scanProgress;
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      Paint()
        ..color = _kGreen.withValues(alpha: (1 - scanProgress) * 0.10)
        ..strokeWidth = 1.0,
    );
  }

  void _corner(Canvas c, Offset o, Paint p, double dx, double dy, double len) {
    c.drawLine(o, o + Offset(dx * len, 0), p);
    c.drawLine(o, o + Offset(0, dy * len), p);
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.scanProgress != scanProgress;
}
