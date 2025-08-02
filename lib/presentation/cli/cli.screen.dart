import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:portfolio/presentation/cli/views/main_screen_view.dart';

import 'controllers/cli.controller.dart';

class CliScreen extends GetView<CliController> {
  const CliScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(child: MainScreenView());
  }
}
