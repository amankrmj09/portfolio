import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infrastructure/theme/colors.dart';
import 'animated_typer_text.dart';
import 'code_block_controller.dart';

class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CodeBlockController());
    return Stack(
      children: [
        Obx(
          () => Positioned(
            left: controller.slideValue.value,
            top: controller.slideValue.value,
            child: Opacity(
              opacity: 0.4,
              child: const Editor(isBackground: true),
            ),
          ),
        ),
        const Editor(),
      ],
    );
  }
}

class Editor extends StatelessWidget {
  const Editor({super.key, this.isBackground = false});

  final bool isBackground;

  @override
  Widget build(BuildContext context) {
    final RxBool isHovered = false.obs;
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: MouseRegion(
          onEnter: (_) => isHovered.value = true,
          onExit: (_) => isHovered.value = false,
          child: Obx(
            () => AnimatedScale(
              scale: isHovered.value ? 1.02 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: InkWell(
                onTap: () => Get.toNamed('/cli'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 420,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF000000),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(left: 25, top: 25, bottom: 25),
                  child: isBackground
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Acrylic macOS Title Bar
                            _buildAcrylicTitleBar(),

                            // Terminal Content
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: 200,
                              ), // adjust as needed
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFF000000), // ✅ Deep black
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: AnimatedTyperText(
                                lines: [
                                  '\$ find / -name "life.dart"\n',
                                  '> Searching . . .\n',
                                  '> Error: No life is found!\n',
                                  '> Since you are a programmer, you have no life!',
                                ],
                                styles: [
                                  const TextStyle(
                                    color: KColor.syntaxGreen,
                                    // Green prompt
                                    fontSize: 15,
                                    fontFamily: 'Courier',
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                  const TextStyle(
                                    color: KColor.syntaxYellow, // Yellow
                                    fontSize: 15,
                                    fontFamily: 'Courier',
                                    height: 1.5,
                                  ),
                                  const TextStyle(
                                    color: KColor.syntaxRed,
                                    // Red error
                                    fontSize: 15,
                                    fontFamily: 'Courier',
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                  TextStyle(
                                    color: const Color(
                                      0xFFE86671,
                                    ).withValues(alpha: 0.9),
                                    fontSize: 15,
                                    fontFamily: 'Courier',
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                ],
                                width: 400,
                                speed: const Duration(milliseconds: 60),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcrylicTitleBar() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // ✅ Acrylic blur
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            // ✅ Semi-transparent gradient for acrylic effect
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              // macOS Traffic Light Buttons
              _buildTrafficLight(KColor.trafficRedAlt, Icons.close),
              const SizedBox(width: 8),
              _buildTrafficLight(KColor.trafficYellowAlt, Icons.minimize),
              const SizedBox(width: 8),
              _buildTrafficLight(const Color(0xFF61C554), Icons.fullscreen),
              const SizedBox(width: 16),
              // Terminal Title
              Expanded(
                child: Center(
                  child: Text(
                    'Terminal',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      // ✅ Brighter on acrylic
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro',
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 80), // Balance for centered title
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrafficLight(Color color, IconData icon) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.5),
      ),
    );
  }
}
