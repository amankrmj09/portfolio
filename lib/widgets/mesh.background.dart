import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:portfolio/infrastructure/theme/colors.dart';

class SharedMeshBackground extends StatefulWidget {
  const SharedMeshBackground({super.key});

  @override
  State<SharedMeshBackground> createState() => _SharedMeshBackgroundState();
}

class _SharedMeshBackgroundState extends State<SharedMeshBackground> {
  late final AnimatedMeshGradientController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimatedMeshGradientController()..start();
  }

  @override
  void dispose() {
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
                painter: _TechGridPainter(),
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = KColor.meshDark2.withValues(alpha: 1)
      ..strokeWidth = 0.5;

    const spacing = 50.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Dots at intersections
    final dotPaint = Paint()
      ..color = KColor.meshDark2.withValues(alpha: 1)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
