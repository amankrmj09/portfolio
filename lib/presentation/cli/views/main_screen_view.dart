import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:portfolio/presentation/cli/controllers/cli.controller.dart';

import '../../../infrastructure/theme/colors.dart';

class MainScreenView extends GetView<CliController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.8,
      height: height * 0.8,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: KColor.borderGrey, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Custom Mac-style app bar
          const _MacTerminalAppBar(),
          // CLI content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _CliContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacDot extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;

  const _MacDot({required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
    );
  }
}

class _CliContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CliController>();
    Color getColor(CliHistoryType type) {
      switch (type) {
        case CliHistoryType.user:
          return KColor.cliPromptGreen; // green for prompt
        case CliHistoryType.output:
          return KColor.cliOutputGrey; // normal output
        case CliHistoryType.error:
          return Colors.redAccent;
      }
    }

    return SingleChildScrollView(
      controller: controller.scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.displayHistory.map((entry) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry.type == CliHistoryType.user)
                      Text(
                        entry.prompt,
                        style: TextStyle(
                          color: getColor(entry.type),
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    Flexible(
                      child: Text(
                        entry.text,
                        style: TextStyle(
                          color: entry.type == CliHistoryType.user
                              ? KColor.cliOutputGrey
                              : getColor(entry.type),
                          fontFamily: 'monospace',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          Row(
            children: [
              Obx(
                () => Text(
                  controller.prompt,
                  style: const TextStyle(
                    color: KColor.cliPromptGreen,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: KeyboardListener(
                  focusNode: FocusNode(),
                  onKeyEvent: controller.onInputKeyEvent,
                  child: TextField(
                    controller: controller.inputController,
                    focusNode: controller.inputFocusNode,
                    showCursor: true,
                    cursorWidth: 8,
                    onTapOutside: (_) {},
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Type a command...',
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                    cursorColor: KColor.cliCursorBlue,
                    onSubmitted: (value) =>
                        controller.onCommandSubmitted(value, context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacTerminalAppBar extends StatelessWidget {
  const _MacTerminalAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: KColor.cliBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: KColor.borderGrey, width: 2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left-aligned Mac window dots
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                _MacDot(
                  color: KColor.trafficRed,
                  onTap: () {
                    Get.back();
                  },
                ),
                SizedBox(width: 8),
                _MacDot(
                  color: KColor.trafficYellow,
                  onTap: () {
                    // Minimize action (optional)
                  },
                ),
                SizedBox(width: 8),
                _MacDot(
                  color: KColor.trafficGreen,
                  onTap: () {
                    // Maximize action (optional)
                  },
                ),
              ],
            ),
          ),
          // Centered terminal text
          const Text(
            'Terminal',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
