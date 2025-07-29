import 'dart:math';

import 'package:aura_box/aura_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/models/project_model/project.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../../widgets/k.image.dart';

class KProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback? onTap;

  final double? width;
  final double? height;
  final bool? fixedHeight;
  final bool? isHome;
  final bool expandToContentHeight;

  const KProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.width = 500,
    this.fixedHeight = true,
    this.height,
    this.isHome = false,
    this.expandToContentHeight = false,
  });

  @override
  State<KProjectCard> createState() => _KProjectCard();
}

class _KProjectCard extends State<KProjectCard> {
  bool isHover = false;
  final GlobalKey _containerKey = GlobalKey();
  Offset _offset = Offset.zero;
  Offset _center = Offset.zero;
  late List<AuraSpot> _auraSpots;

  void _updateOffset(PointerEvent details) {
    final RenderBox? box =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      final size = box.size;
      setState(() {
        _center = position + Offset(size.width / 2, size.height / 2);
        _offset = details.position - _center;
      });
    } else {
      setState(() {
        _offset = Offset.zero;
      });
    }
  }

  void _resetOffset() {
    setState(() {
      _offset = Offset.zero;
    });
  }

  @override
  void initState() {
    _auraSpots = randomizeAuraSpots();
    super.initState();
  }

  final Random _random = Random();

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

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    final isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    final bool expandToContent = widget.expandToContentHeight;
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
              (_offset.dx / ((widget.width ?? 500) / 2)).clamp(-1.0, 1.0),
              (_offset.dy / ((widget.height ?? 500) / 2)).clamp(-1.0, 1.0),
            ),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                key: _containerKey,
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.all(8),
                width: isMobile
                    ? (MediaQuery.of(context).size.width * 0.45 > 340
                          ? MediaQuery.of(context).size.width * 0.45
                          : 340)
                    : widget.width,
                height: expandToContent ? null : widget.height,
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
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Column(
                      mainAxisSize: expandToContent
                          ? MainAxisSize.min
                          : MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: isMobile ? 320 : 380,
                          child: KImage(url: widget.project.images[0]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: expandToContent
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.project.name,
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
                                      widget.project.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontFamily: "Poppins",
                                        decoration: TextDecoration.none,
                                      ),
                                      maxLines: widget.fixedHeight == true
                                          ? 2
                                          : null,
                                      overflow: widget.fixedHeight == true
                                          ? TextOverflow.ellipsis
                                          : null,
                                      softWrap: true,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.project.largeDescription,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                        fontFamily: "Poppins",
                                        decoration: TextDecoration.none,
                                      ),
                                      maxLines: widget.fixedHeight == true
                                          ? 5
                                          : null,
                                      overflow: widget.fixedHeight == true
                                          ? TextOverflow.ellipsis
                                          : null,
                                      softWrap: true,
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height:
                                      (widget.height ?? 500) -
                                      (isMobile ? 320 : 380) -
                                      52,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.project.name,
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
                                        widget.project.description,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white70,
                                          fontFamily: "Poppins",
                                          decoration: TextDecoration.none,
                                        ),
                                        maxLines: widget.fixedHeight == true
                                            ? 2
                                            : null,
                                        overflow: widget.fixedHeight == true
                                            ? TextOverflow.ellipsis
                                            : null,
                                        softWrap: true,
                                      ),
                                      const SizedBox(height: 8),
                                      if (widget.isHome == true)
                                        Text(
                                          widget.project.largeDescription,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white70,
                                            fontFamily: "Poppins",
                                            decoration: TextDecoration.none,
                                          ),
                                          maxLines: widget.fixedHeight == true
                                              ? 5
                                              : null,
                                          overflow: widget.fixedHeight == true
                                              ? TextOverflow.ellipsis
                                              : TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                    ],
                                  ),
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
