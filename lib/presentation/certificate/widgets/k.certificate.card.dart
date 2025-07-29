import 'dart:math';

import 'package:aura_box/aura_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/models/certificate_model/certificate.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../widgets/k.image.dart';

// --- Extracted sub-widgets for optimization ---

class SkillChips extends StatelessWidget {
  final List<String> skills;
  final int maxChipsToShow; // -1 for all

  const SkillChips({super.key, required this.skills, this.maxChipsToShow = 3});

  @override
  Widget build(BuildContext context) {
    final displaySkills = maxChipsToShow < 0
        ? skills
        : skills.take(maxChipsToShow).toList();
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: displaySkills.map((skill) => Chip(label: Text(skill))).toList(),
    );
  }
}

class CertificateDetailsCompact extends StatelessWidget {
  final CertificateModel certificate;

  const CertificateDetailsCompact({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 2),
        Text(
          certificate.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "Poppins",
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          certificate.description,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white70,
            fontFamily: "Poppins",
            decoration: TextDecoration.none,
          ),
          maxLines: 2,
          softWrap: true,
        ),
        const SizedBox(height: 10),
        SkillChips(skills: certificate.skills, maxChipsToShow: 3),
      ],
    );
  }
}

class CertificateDetailsExpanded extends StatelessWidget {
  final CertificateModel certificate;
  final bool isMobile;

  const CertificateDetailsExpanded({
    super.key,
    required this.certificate,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          certificate.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "Poppins",
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          certificate.description,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white70,
            fontFamily: "Poppins",
            decoration: TextDecoration.none,
          ),
          softWrap: true,
        ),
        const SizedBox(height: 8),
        Text(
          certificate.largeDescription,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
            fontFamily: "Poppins",
            decoration: TextDecoration.none,
          ),
          maxLines: isMobile ? 4 : 8,
          softWrap: true,
        ),
        const SizedBox(height: 10),
        SkillChips(skills: certificate.skills, maxChipsToShow: -1),
      ],
    );
  }
}

// --- Main Card Widget ---

class KCertificateCard extends StatefulWidget {
  final CertificateModel certificate;
  final VoidCallback? onTap;

  final double? width;
  final double? height;
  final bool isHome;
  final bool expandToContentHeight;

  const KCertificateCard({
    super.key,
    required this.certificate,
    this.onTap,
    this.width = 500,
    this.height,
    required this.isHome,
    this.expandToContentHeight = false,
  });

  @override
  State<KCertificateCard> createState() => _KCertificateCard();
}

class _KCertificateCard extends State<KCertificateCard> {
  bool isHover = false;
  final GlobalKey _containerKey = GlobalKey();
  Offset _offset = Offset.zero;
  Offset _center = Offset.zero;

  late final List<AuraSpot> _auraSpots;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _auraSpots = randomizeAuraSpots();
  }

  List<AuraSpot> randomizeAuraSpots() {
    // Minimum values
    const minRadius = 50.0;
    const maxRadius = 180.0;
    const minBlur = 4.0;
    const maxBlur = 16.0;
    final alignments = [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
      Alignment.center,
      Alignment.centerLeft,
      Alignment.centerRight,
      Alignment.topCenter,
      Alignment.bottomCenter,
    ];
    final colors = [
      Color(0xFF7F53AC), // Soft Purple
      Color(0xFF647DEE), // Blue Violet
      Color(0xFF43C6AC), // Aqua Green
      Color(0xFFF7971E), // Warm Gold Accent
    ];
    return List.generate(colors.length, (i) {
      final double radius =
          minRadius + _random.nextDouble() * (maxRadius - minRadius);
      final double blurRadius =
          minBlur + _random.nextDouble() * (maxBlur - minBlur);
      final Alignment alignment =
          alignments[_random.nextInt(alignments.length)];
      return AuraSpot(
        color: colors[i],
        radius: radius,
        alignment: alignment,
        blurRadius: blurRadius,
      );
    });
  }

  void _updateOffset(PointerEvent details) {
    final RenderBox? box =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      final Offset newCenter =
          position + Offset(size.width / 2, size.height / 2);
      final Offset newOffset = details.position - newCenter;
      if (newOffset != _offset || newCenter != _center) {
        setState(() {
          _center = newCenter;
          _offset = newOffset;
        });
      }
    } else if (_offset != Offset.zero) {
      setState(() {
        _offset = Offset.zero;
      });
    }
  }

  void _resetOffset() {
    if (_offset != Offset.zero) {
      setState(() {
        _offset = Offset.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    final expandToContent = widget.expandToContentHeight;

    final mediaWidth = MediaQuery.of(context).size.width;
    final double cardWidth = isMobile
        ? (mediaWidth * 0.45 > 340 ? mediaWidth * 0.45 : 340)
        : widget.width ?? 500;

    final double? cardHeight = widget.height;
    final double contentHeight =
        (cardHeight ?? 500) - (isMobile ? 320 : 380) - 52;

    return MouseRegion(
      cursor: isHover ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) {
        setState(() => isHover = false);
        _resetOffset();
      },
      onHover: _updateOffset,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: isHover ? 0.98 : 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: AnimatedAlign(
            alignment: Alignment(
              (_offset.dx / (cardWidth / 2)).clamp(-1.0, 1.0),
              (_offset.dy / ((cardHeight ?? 500) / 2)).clamp(-1.0, 1.0),
            ),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                key: _containerKey,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(8),
                width: cardWidth,
                height: expandToContent ? null : cardHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.lerp(Colors.white, Colors.black, 0.5)!,
                    width: 1,
                  ),
                  color: Color.lerp(
                    Colors.deepPurpleAccent,
                    Colors.transparent,
                    0.65,
                  )!,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: RepaintBoundary(
                  child: AuraBox(
                    spots: _auraSpots,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      mainAxisSize: expandToContent
                          ? MainAxisSize.min
                          : MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: isMobile ? 300 : 380,
                          child: KImage(url: widget.certificate.images[0]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: expandToContent
                              ? CertificateDetailsExpanded(
                                  certificate: widget.certificate,
                                  isMobile: isMobile,
                                )
                              : CertificateDetailsCompact(
                                  certificate: widget.certificate,
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
      ),
    );
  }
}
