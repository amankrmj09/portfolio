import 'package:portfolio/presentation/info.fetch.controller.dart';
import 'package:portfolio/presentation/footer/views/contact_me_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/colors.dart';
import '../../utils/k.showGeneralDialog.dart';
import 'controllers/footer.controller.dart';

class FooterScreen extends GetView<FooterController> {
  const FooterScreen({super.key});

  static const Color _primaryAccent = KColor.meshGlow; // Cyan
  static const Color _secondaryAccent = Color(0xFF7B2DFF); // Purple
  static const Color _footerForegroundColor = Color(0xFFE0E0E0);

  Widget _quoteSection({bool isMobile = false}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: _primaryAccent),
        );
      } else if (controller.quotes.isEmpty) {
        return Center(
          child: Text(
            'No quotes available',
            style: TextStyle(color: _footerForegroundColor),
          ),
        );
      } else {
        final quotes = controller.quotes;
        final quote = (quotes.toList()..shuffle()).first;
        return Padding(
          padding: EdgeInsets.all(isMobile ? 24.0 : 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Quote icon with gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_primaryAccent, _secondaryAccent],
                ).createShader(bounds),
                child: const Icon(
                  Icons.format_quote_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Quote text with gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_primaryAccent, Colors.white, _secondaryAccent],
                  stops: [0.0, 0.5, 1.0],
                ).createShader(bounds),
                child: Text(
                  quote.quote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 36,
                    fontFamily: "ShantellSans",
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Author with decorative lines
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.transparent, _primaryAccent],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    quote.author,
                    style: TextStyle(
                      color: _primaryAccent,
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_primaryAccent, Colors.transparent],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _footerWelcomePart({bool isMobile = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decorative code bracket
        Text(
          '<collaborate>',
          style: TextStyle(
            color: _primaryAccent.withValues(alpha: 0.6),
            fontSize: isMobile ? 12 : 14,
            fontFamily: 'monospace',
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [_primaryAccent, _secondaryAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Let's Build Together",
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              fontFamily: 'ShantellSans',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _PulsingDot(),
            const SizedBox(width: 8),
            Text(
              "Available for Freelancing",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _footerForegroundColor.withValues(alpha: 0.8),
                fontSize: isMobile ? 16 : 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '</collaborate>',
          style: TextStyle(
            color: _primaryAccent.withValues(alpha: 0.6),
            fontSize: isMobile ? 12 : 14,
            fontFamily: 'monospace',
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _footerSocial({required bool swap}) {
    return _GlowingButton(
      onTap: () {
        showBlurredGeneralDialog(
          context: Get.context!,
          builder: (context) => ContactMeView(),
        );
      },
    );
  }

  Widget _madeWithFlutterLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: _primaryAccent.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '{ ',
            style: TextStyle(
              color: _primaryAccent,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            'Built with ',
            style: TextStyle(
              color: _footerForegroundColor.withValues(alpha: 0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const FlutterLogo(size: 18),
          Text(' + ', style: TextStyle(color: _primaryAccent, fontSize: 14)),
          const Icon(Icons.favorite, color: Colors.redAccent, size: 18),
          Text(
            ' }',
            style: TextStyle(
              color: _primaryAccent,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    bool isMobile = infoFetchController.currentDevice.value == Device.Mobile;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: isMobile ? kToolbarHeight : 80),
          const _SectionDivider(),
          Expanded(flex: 5, child: _quoteSection(isMobile: isMobile)),
          const _SectionDivider(),
          isMobile
              ? Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _footerWelcomePart(isMobile: isMobile),
                        const SizedBox(height: 20),
                        _footerSocial(swap: true),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 1, child: _footerWelcomePart()),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _madeWithFlutterLabel(),
                              const SizedBox(height: 16),
                              _CopyrightLabel(),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: _footerSocial(swap: false)),
                        ),
                      ],
                    ),
                  ),
                ),
          // _BottomBar(isMobile: isMobile),
        ],
      ),
    );
  }
}

// Glowing contact button
class _GlowingButton extends StatefulWidget {
  final VoidCallback onTap;

  const _GlowingButton({required this.onTap});

  @override
  State<_GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<_GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    KColor.meshGlow,
                    Color.lerp(
                      KColor.meshGlow,
                      const Color(0xFF7B2DFF),
                      _controller.value,
                    )!,
                    const Color(0xFF7B2DFF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF00D9FF,
                    ).withValues(alpha: _isHovered ? 0.6 : 0.3),
                    blurRadius: _isHovered ? 20 : 12,
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/contact_me.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Let's Connect",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isHovered ? 0.1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Pulsing status dot
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF00FF88),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF00FF88,
                ).withValues(alpha: _controller.value * 0.6),
                blurRadius: 8,
                spreadRadius: 2 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Section divider with gradient line
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            KColor.meshGlow.withValues(alpha: 0.5),
            const Color(0xFF7B2DFF).withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

// Copyright label
class _CopyrightLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '© ${DateTime.now().year} Aman Kumar',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 13,
        fontFamily: 'monospace',
        letterSpacing: 1,
      ),
    );
  }
}

// Bottom bar
class _BottomBar extends StatelessWidget {
  final bool isMobile;

  const _BottomBar({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: isMobile ? 20 : 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isMobile)
            Row(
              children: [
                const _TerminalText(text: '~/portfolio'),
                const SizedBox(width: 8),
                const _BlinkingCursor(),
              ],
            ),
          if (isMobile) _CopyrightLabel(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _StatusBadge(label: 'v4.0.6', color: KColor.meshGlow),
              const SizedBox(width: 12),
              const _StatusBadge(label: 'Flutter', color: Color(0xFF02569B)),
            ],
          ),
        ],
      ),
    );
  }
}

// Terminal-style text
class _TerminalText extends StatelessWidget {
  final String text;

  const _TerminalText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF00FF88),
        fontSize: 13,
        fontFamily: 'monospace',
      ),
    );
  }
}

// Blinking cursor
class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Container(
            width: 8,
            height: 16,
            color: const Color(0xFF00FF88),
          ),
        );
      },
    );
  }
}

// Status badge
class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

// Footer Widgets helper class for reusable components
class FooterWidgets {
  static Widget ccLabel(Color color) {
    return Text(
      '© ${DateTime.now().year} Aman Kumar',
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontFamily: 'monospace',
        letterSpacing: 1,
      ),
    );
  }
}
