import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/presentation/about_me/controllers/about_me.controller.dart';
import '../widgets/profile.widget.dart';

class ProfilesView extends GetView<AboutMeController> {
  const ProfilesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 32,
          vertical: isMobile ? 40 : 60,
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 800,
            ),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A1628).withAlpha((0.95 * 255).toInt()),
                  const Color(0xFF001529).withAlpha((0.9 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).toInt()),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.5 * 255).toInt()),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                _buildHeader(context),
                const SizedBox(height: 20),

                // Profiles content
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: isMobile ? 16 : 24,
                      runSpacing: isMobile ? 16 : 24,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        ...(List.from(controller.profiles)..shuffle()).map(
                          (profile) => ProfileWidget(
                            profile: profile,
                            disableHover: isMobile, // ✅ Disable hover on mobile
                          ),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 48), // Balance close button
        Expanded(
          child: Text(
            'Profiles',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white.withAlpha((0.95 * 255).toInt()),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Close button
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B0000).withAlpha((0.5 * 255).toInt()),
                  const Color(0xFF4B0000).withAlpha((0.4 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF4444).withAlpha((0.4 * 255).toInt()),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.close_rounded,
              color: Colors.white.withAlpha((0.95 * 255).toInt()),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
