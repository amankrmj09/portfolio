import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:portfolio/presentation/about_me/controllers/about_me.controller.dart';
import 'package:portfolio/presentation/about_me/widgets/tool.widget.dart';

class ToolsView extends GetView<AboutMeController> {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.lerp(Colors.black, Colors.transparent, 0.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    'Tools',
                    style: TextStyle(
                      fontFamily: 'ShantellSans',
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 24.0,
                    runSpacing: 24.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      ...(List.from(
                        controller.tools,
                      )..shuffle()).map((tool) => ToolWidget(tool: tool)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
