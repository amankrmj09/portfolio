import 'dart:math';

import 'package:aura_box/aura_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/domain/models/contact_details_model/contact.details.model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../infrastructure/theme/colors.dart';

class FileCard extends StatefulWidget {
  final ContactDetailsModel file;

  const FileCard({super.key, required this.file});

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> with TickerProviderStateMixin {
  bool expanded = false;
  bool _isWhatsappHovered = false;
  late final List<AuraSpot> _auraSpots;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _auraSpots = _randomizeAuraSpots();
  }

  List<AuraSpot> _randomizeAuraSpots() {
    const minRadius = 50.0, maxRadius = 180.0, minBlur = 4.0, maxBlur = 16.0;
    const alignments = [
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
      KColor.gradientPurple,
      KColor.gradientIndigo,
      KColor.gradientTeal,
      KColor.gradientOrange,
    ];
    return List.generate(
      colors.length,
      (i) => AuraSpot(
        color: colors[i],
        radius: minRadius + _random.nextDouble() * (maxRadius - minRadius),
        alignment: alignments[_random.nextInt(alignments.length)],
        blurRadius: minBlur + _random.nextDouble() * (maxBlur - minBlur),
      ),
    );
  }

  void _launchWhatsapp() {
    final file = widget.file;
    final whatsappUrl =
        'https://wa.me/${file.countryCode}${file.phoneNumber}?text=Hello';
    launchUrl(Uri.parse(whatsappUrl));
  }

  Widget _buildContactDetails(ContactDetailsModel file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name: ${file.name}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.95),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Phone: ${file.phoneNumber}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.85),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Email: ${file.email}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.85),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Message:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.amberAccent.shade200,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          file.message,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.92),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.file;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.lerp(Colors.transparent, Colors.white, 0.6)!,
          width: 1,
        ),
      ),
      child: RepaintBoundary(
        child: AuraBox(
          spots: _auraSpots,
          decoration: BoxDecoration(
            color: Color.lerp(Colors.black, Colors.transparent, 0.8),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        file.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _isWhatsappHovered = true),
                      onExit: (_) => setState(() => _isWhatsappHovered = false),
                      child: GestureDetector(
                        onTap: _launchWhatsapp,
                        child: AnimatedScale(
                          scale: _isWhatsappHovered ? 1.2 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: SvgPicture.asset(
                            'assets/icons/WhatsApp.svg',
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      "${file.date}  ${file.time}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    AnimatedRotation(
                      turns: expanded ? -0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: IconButton(
                        icon: const Icon(Icons.expand_more),
                        onPressed: () => setState(() => expanded = !expanded),
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  alignment: Alignment.centerLeft,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: _buildContactDetails(file),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
