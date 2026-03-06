import 'package:flutter/material.dart';

/// Custom Vertical Divider Widget
class CustomVerticalDivider extends StatelessWidget {
  const CustomVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      indent: 6,
      endIndent: 12,
      width: 16,
      thickness: 2,
      color: Colors.black,
    );
  }
}
