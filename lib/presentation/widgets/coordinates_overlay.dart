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
  late AnimationController _drift; // drives passive 1 AU/sec

  // ── Distance tracking ──────────────────────────────────────────────────
  double _totalAU = 0.0; // accumulated distance in AU
  double _displayAU = 0.0; // smoothly interpolated display value
  DateTime _lastDriftTick = DateTime.now();

  // ── Smooth position interpolation ──────────────────────────────────────
  Offset _currentPos = Offset.zero; // smoothly lerped display position
  double _currentAngle = 0.0; // smoothly lerped angle in degrees
  bool _initialized = false;

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

    // Drift ticker: fires every frame, adds 1 AU per elapsed second
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
    _drift.addListener(_onDriftTick);
    _lastDriftTick = DateTime.now();
  }

  void _onDriftTick() {
    final now = DateTime.now();
    final dt = now.difference(_lastDriftTick).inMicroseconds / 1e6; // seconds
    _lastDriftTick = now;

    // Passive drift: 1 AU per second
    _totalAU += dt;

    // Smooth display lerp (~12% per frame toward target)
    _displayAU += (_totalAU - _displayAU) * 0.12;

    // Smooth position lerp (~6% per frame — matches mesh grid smoothness)
    final target = widget.position;
    final cx = widget.containerWidth / 2;
    final cy = widget.containerHeight / 2;

    // Raw target angle from the actual widget position (not the lerped one)
    final targetAngle =
        math.atan2(-(target.dy - cy), (target.dx - cx)) * 180 / math.pi;

    if (!_initialized) {
      _currentPos = target;
      _currentAngle = targetAngle;
      _initialized = true;
    } else {
      final dx = _currentPos.dx + (target.dx - _currentPos.dx) * 0.06;
      final dy = _currentPos.dy + (target.dy - _currentPos.dy) * 0.06;
      _currentPos = Offset(dx, dy);

      // Shortest-path lerp toward the real target angle
      double diff = targetAngle - _currentAngle;
      if (diff > 180) diff -= 360;
      if (diff < -180) diff += 360;
      _currentAngle += diff * 0.06;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _drift.removeListener(_onDriftTick);
    _drift.dispose();
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
    // Use smoothly lerped position so values glide to zero on mouse exit
    final x = ((_currentPos.dx - cx) * dpr).round();
    final y = (-(_currentPos.dy - cy) * dpr).round();

    // Smoothly lerped angle (computed in _onDriftTick)
    final angle = _currentAngle;

    // Sign labels for readability
    final xLabel = x >= 0 ? '+$x' : '$x';
    final yLabel = y >= 0 ? '+$y' : '$y';

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _scan,
            builder: (_, _) =>
                CustomPaint(painter: _FramePainter(scanProgress: _scan.value)),
          ),
        ),
        Container(
          width: 145,
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          decoration: BoxDecoration(
            color: _kBg,
            border: Border.all(color: _kDimGreen, width: 0.5),
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
                    builder: (_, _) => Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _kGreen.withValues(alpha: _blink.value),
                        boxShadow: [
                          BoxShadow(
                            color: _kGreen.withValues(
                              alpha: _blink.value * 0.8,
                            ),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'NAV  LOCK',
                    style: TextStyle(
                      color: _kGreen.withValues(alpha: 0.45),
                      fontSize: 6.5,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(height: 0.5, color: _kDimGreen),
              const SizedBox(height: 5),
              _AxisRow(label: 'X', value: xLabel),
              const SizedBox(height: 3),
              _AxisRow(label: 'Y', value: yLabel),
              const SizedBox(height: 5),
              Container(height: 0.5, color: _kDimGreen),
              const SizedBox(height: 4),
              Text(
                '∠  ${angle.toStringAsFixed(1)}°',
                style: TextStyle(
                  color: _kGreen.withValues(alpha: 0.35),
                  fontSize: 6.5,
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '⟿  ${_displayAU.toStringAsFixed(1)} AU',
                style: TextStyle(
                  color: _kGreen.withValues(alpha: 0.35),
                  fontSize: 6.5,
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
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
          width: 12,
          height: 12,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: _kGreen.withValues(alpha: 0.35),
              width: 0.7,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: _kGreen.withValues(alpha: 0.6),
              fontSize: 7,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            color: _kGreen,
            fontSize: 10.5,
            fontFamily: 'monospace',
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(color: _kGreen.withValues(alpha: 0.55), blurRadius: 5),
            ],
          ),
        ),
        const SizedBox(width: 3),
        Text(
          'px',
          style: TextStyle(
            color: _kGreen.withValues(alpha: 0.25),
            fontSize: 6.5,
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
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const len = 7.0;

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
