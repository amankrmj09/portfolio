import 'dart:async';
import 'dart:math';

import 'package:aura_box/aura_box.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/experience_model/experience.model.dart';

class AnimatedExperienceCard extends StatefulWidget {
  final List<ExperienceModel> experiences;
  final Duration duration;
  final double width;

  const AnimatedExperienceCard({
    super.key,
    required this.experiences,
    this.duration = const Duration(seconds: 5),
    required this.width,
  });

  @override
  State<AnimatedExperienceCard> createState() => _AnimatedExperienceCardState();
}

class _AnimatedExperienceCardState extends State<AnimatedExperienceCard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _nextIndex = 0;
  bool _showNext = false;
  Timer? _timer;

  late AnimationController _controller;
  late AnimationController _controllerLine;
  late Animation<Alignment> _alignmentAnim;
  late Animation<Alignment> _alignmentAnimLine;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controllerLine = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _alignmentAnim = Tween<Alignment>(
      begin: Alignment.center,
      end: const Alignment(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _alignmentAnimLine =
        Tween<Alignment>(
          begin: Alignment.center,
          end: const Alignment(0, -5),
        ).animate(
          CurvedAnimation(parent: _controllerLine, curve: Curves.easeInOut),
        );
    _opacityAnim = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _timer = Timer.periodic(widget.duration, (_) {
      if (!mounted) return;
      setState(() {
        _nextIndex = (_currentIndex + 1) % widget.experiences.length;
        _showNext = false;
      });
      _controller.forward(from: 0).then((_) {
        if (!mounted) return;
        setState(() {
          _currentIndex = _nextIndex;
          _showNext = true;
        });
        _controller.reverse(from: 1.0);
      });
      _controllerLine.forward(from: 0).then((_) {
        if (!mounted) return;
        _controllerLine.reverse(from: 1.0);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _controllerLine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width < 650 ? widget.width : 650,
      height: 280,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (!_showNext) {
            return Align(
              alignment: _alignmentAnim.value,
              child: Opacity(
                opacity: _opacityAnim.value,
                child: ExperienceCard(
                  width: widget.width,
                  exp: widget.experiences[_currentIndex],
                ),
              ),
            );
          } else {
            return Align(
              alignment: Alignment.lerp(
                const Alignment(0, 1),
                Alignment.center,
                1 - _controller.value,
              )!,
              child: Opacity(
                opacity: 1 - _controller.value,
                child: ExperienceCard(
                  width: widget.width,
                  exp: widget.experiences[_currentIndex],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ExperienceCard extends StatefulWidget {
  final ExperienceModel exp;
  final double width;

  const ExperienceCard({super.key, required this.exp, required this.width});

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  late List<AuraSpot> _auraSpots;

  @override
  void initState() {
    _auraSpots = randomizeAuraSpots();
    super.initState();
  }

  final Random _random = Random();

  List<AuraSpot> randomizeAuraSpots() {
    const minRadius = 60.0;
    const maxRadius = 200.0;
    const minBlur = 6.0;
    const maxBlur = 20.0;
    final alignments = [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
      Alignment.center,
    ];
    final colors = [
      const Color(0xFF0A4A8E).withAlpha((0.4 * 255).toInt()),
      const Color(0xFF001529).withAlpha((0.3 * 255).toInt()),
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
    final exp = widget.exp;
    return Container(
      clipBehavior: Clip.hardEdge,
      width: widget.width < 600 ? widget.width : 600,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withAlpha((0.4 * 255).toInt()),
          width: 1.5,
        ),
      ),
      child: RepaintBoundary(
        child: AuraBox(
          spots: _auraSpots,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0A1628).withAlpha((0.95 * 255).toInt()),
                const Color(0xFF001529).withAlpha((0.85 * 255).toInt()),
              ],
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title with accent
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A4A8E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        exp.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ShantellSans',
                          color: Colors.white.withAlpha((0.95 * 255).toInt()),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Company and Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 16,
                            color: Colors.white.withAlpha((0.7 * 255).toInt()),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              exp.company,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withAlpha(
                                  (0.85 * 255).toInt(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (exp.location.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white.withAlpha((0.7 * 255).toInt()),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            exp.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha(
                                (0.7 * 255).toInt(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.white.withAlpha((0.6 * 255).toInt()),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${exp.startDate} - ${exp.endDate}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withAlpha((0.6 * 255).toInt()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Description
                Text(
                  exp.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white.withAlpha((0.85 * 255).toInt()),
                  ),
                ),
                if (exp.technologies.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  // Technologies
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: exp.technologies.take(4).map((tech) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(
                                0xFF0A4A8E,
                              ).withAlpha((0.3 * 255).toInt()),
                              const Color(
                                0xFF001529,
                              ).withAlpha((0.2 * 255).toInt()),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFF0A4A8E,
                            ).withAlpha((0.4 * 255).toInt()),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withAlpha((0.9 * 255).toInt()),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
