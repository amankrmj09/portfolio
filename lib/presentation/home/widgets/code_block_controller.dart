import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeBlockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> slideEditor;
  final RxDouble slideValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    slideEditor =
        Tween<double>(begin: 0, end: -20).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOut),
        )..addListener(() {
          slideValue.value = slideEditor.value;
        });
    controller.forward();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
