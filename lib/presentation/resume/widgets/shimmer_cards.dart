import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int count;

  const ShimmerList({this.count = 3, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(count, (index) => const ShimmerCard()),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withAlpha((0.08 * 255).toInt()),
      highlightColor: Colors.white.withAlpha((0.18 * 255).toInt()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.08 * 255).toInt()),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withAlpha((0.15 * 255).toInt()),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 22,
              color: Colors.white.withAlpha((0.18 * 255).toInt()),
            ),
            const SizedBox(height: 8),
            Container(
              width: 80,
              height: 16,
              color: Colors.white.withAlpha((0.15 * 255).toInt()),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 15,
              color: Colors.white.withAlpha((0.12 * 255).toInt()),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 15,
              color: Colors.white.withAlpha((0.12 * 255).toInt()),
            ),
          ],
        ),
      ),
    );
  }
}
