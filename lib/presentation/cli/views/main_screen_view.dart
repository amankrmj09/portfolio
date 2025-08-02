import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:portfolio/presentation/cli/controllers/cli.controller.dart';

class MainScreenView extends GetView<CliController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Container(
          width: width * 0.8,
          height: height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFF232323),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: const Color(0xFF444444), width: 2),
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
        ),
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
          border: Border.all(color: Colors.black.withOpacity(0.15), width: 1),
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
          return const Color(0xFF6A9955); // green for prompt
        case CliHistoryType.output:
          return const Color(0xFFD4D4D4); // normal output
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
                              ? const Color(0xFFD4D4D4)
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
              Text(
                'user@${controller.userName}',
                style: const TextStyle(
                  color: Color(0xFF6A9955),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  fontSize: 16,
                ),
              ),
              const Text(
                ' ~ ',
                style: TextStyle(
                  color: Color(0xFF9CDCFE),
                  fontFamily: 'monospace',
                  fontSize: 16,
                ),
              ),
              const Text(
                '\$',
                style: TextStyle(
                  color: Color(0xFFD4D4D4),
                  fontFamily: 'monospace',
                  fontSize: 16,
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
                    cursorColor: Color(0xFF9CDCFE),
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
        color: Color(0xFF232323),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: Color(0xFF444444), width: 2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Mac window dots with InkWell
          Row(
            children: [
              _MacDot(
                color: Color(0xFFFF5F56),
                onTap: () {
                  // Close action (optional: Navigator maybe)
                },
              ),
              SizedBox(width: 8),
              _MacDot(
                color: Color(0xFFFFBD2E),
                onTap: () {
                  // Minimize action (optional)
                },
              ),
              SizedBox(width: 8),
              _MacDot(
                color: Color(0xFF27C93F),
                onTap: () {
                  // Maximize action (optional)
                },
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'Terminal',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
