import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/infrastructure/theme/colors.dart';

void kSnackbar({
  required String title,
  required String message,
  IconData? prefixIcon,
  IconData? suffixIcon,
  Color backgroundColor = Colors.black,
  Color titleColor = Colors.white,
  Color messageColor = Colors.white,
  SnackPosition snackPosition = SnackPosition.TOP,
}) {
  Get.snackbar(
    '',
    '',
    titleText: Row(
      children: [
        if (prefixIcon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(prefixIcon, color: titleColor, size: 20),
          ),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (suffixIcon != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(suffixIcon, color: titleColor, size: 20),
          ),
      ],
    ),
    messageText: Text(
      message,
      style: TextStyle(color: messageColor, fontSize: 14),
    ),
    backgroundColor: backgroundColor.withValues(alpha: 0.3),
    borderRadius: 12,
    borderWidth: 2,
    borderColor: KColor.accentBlue,
    // blackish blue
    margin: const EdgeInsets.all(16),
    snackPosition: snackPosition,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
  );
}
