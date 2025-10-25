import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/launch.url.dart';
import '../../../utils/k.snackbar.dart';

class SideBar extends StatefulWidget {
  final ValueChanged<int>? onIndexChanged;
  final List<Map<String, dynamic>> menuData;
  final String? resumeUrl; // Optional resume URL

  const SideBar({
    super.key,
    this.onIndexChanged,
    required this.menuData,
    this.resumeUrl,
  });

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedIndex = 0;
  int? hoverIndex;
  bool isBackButtonHovered = false;
  bool isDownloadButtonHovered = false;

  // Helper to replace deprecated withOpacity with withAlpha
  Color _withOpacity(Color color, double opacity) {
    if (opacity >= 1.0) return color;
    if (opacity <= 0.0) return color.withAlpha(0);
    return color.withAlpha((opacity * 255).round());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _withOpacity(const Color(0xFF0A1628), 0.85),
            _withOpacity(const Color(0xFF000108), 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _withOpacity(const Color(0xFF0A4A8E), 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _withOpacity(Colors.black, 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      width: 250,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Resume title and back button
          _buildHeader(),
          const SizedBox(height: 24),

          // Navigation label
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 16),
            child: Text(
              'NAVIGATION',
              style: TextStyle(
                color: _withOpacity(Colors.white, 0.5),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Menu items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < widget.menuData.length; i++)
                    buildMenuButton(
                      widget.menuData[i]['title'] as String,
                      widget.menuData[i]['icon'] as IconData,
                      i,
                    ),
                ],
              ),
            ),
          ),

          // Download Resume Button at bottom
          const SizedBox(height: 16),
          _buildDownloadResumeButton(),
        ],
      ),
    );
  }

  // Header with Resume title and back button
  Widget _buildHeader() {
    return MouseRegion(
      onEnter: (_) => setState(() => isBackButtonHovered = true),
      onExit: (_) => setState(() => isBackButtonHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isBackButtonHovered
                ? [
                    _withOpacity(const Color(0xFF8B0000), 0.4),
                    _withOpacity(const Color(0xFF4B0000), 0.3),
                  ]
                : [
                    _withOpacity(const Color(0xFF6B0000), 0.3),
                    _withOpacity(const Color(0xFF3B0000), 0.2),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isBackButtonHovered
                ? _withOpacity(const Color(0xFFFF4444), 0.4)
                : _withOpacity(const Color(0xFF8B0000), 0.3),
            width: 1.5,
          ),
          boxShadow: isBackButtonHovered
              ? [
                  BoxShadow(
                    color: _withOpacity(const Color(0xFFFF4444), 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          onTap: () {
            Get.back();
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: _withOpacity(const Color(0xFFFF4444), 0.2),
          highlightColor: _withOpacity(const Color(0xFFFF4444), 0.1),
          child: Stack(
            children: [
              // Centered title that shifts right on hover
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isBackButtonHovered
                    ? Alignment.center
                    : Alignment.center,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.only(left: isBackButtonHovered ? 20 : 0),
                  child: Text(
                    'RESUME',
                    style: TextStyle(
                      color: _withOpacity(Colors.white, 0.95),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // Back button that fades in from left
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: isBackButtonHovered ? 0 : -40,
                top: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  opacity: isBackButtonHovered ? 1.0 : 0.0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _withOpacity(const Color(0xFFFF4444), 0.3),
                            _withOpacity(const Color(0xFFFF4444), 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: _withOpacity(Colors.white, 0.95),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Download Resume Button
  Widget _buildDownloadResumeButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => isDownloadButtonHovered = true),
      onExit: (_) => setState(() => isDownloadButtonHovered = false),
      child: AnimatedContainer(
        height: 60,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDownloadButtonHovered
                ? [
                    _withOpacity(const Color(0xFF00C853), 0.5), // Bright green
                    _withOpacity(const Color(0xFF00A843), 0.4),
                  ]
                : [
                    _withOpacity(const Color(0xFF00A843), 0.4), // Dark green
                    _withOpacity(const Color(0xFF008833), 0.3),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDownloadButtonHovered
                ? _withOpacity(const Color(0xFF00C853), 0.6)
                : _withOpacity(const Color(0xFF00A843), 0.4),
            width: 1.5,
          ),
          boxShadow: isDownloadButtonHovered
              ? [
                  BoxShadow(
                    color: _withOpacity(const Color(0xFF00C853), 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          onTap: () {
            if (widget.resumeUrl != null && widget.resumeUrl!.isNotEmpty) {
              launchUrlExternal(widget.resumeUrl!);
            } else {
              kSnackbar(
                title: 'Resume URL',
                message:
                    'Some error occurred while trying to download the resume.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                titleColor: Colors.white,
                messageColor: Colors.white,
                prefixIcon: Icons.error_outline,
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: _withOpacity(const Color(0xFF00C853), 0.2),
          highlightColor: _withOpacity(const Color(0xFF00C853), 0.1),
          child: Stack(
            children: [
              // Centered text that shifts right on hover
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.only(
                    left: isDownloadButtonHovered ? 20 : 0,
                  ),
                  child: Text(
                    'Download My Resume',
                    style: TextStyle(
                      color: _withOpacity(Colors.white, 0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Download icon that fades in from left
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: isDownloadButtonHovered ? 0 : -40,
                top: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  opacity: isDownloadButtonHovered ? 1.0 : 0.0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _withOpacity(const Color(0xFF00C853), 0.3),
                            _withOpacity(const Color(0xFF00C853), 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.download_rounded,
                        color: _withOpacity(Colors.white, 0.95),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(String title, IconData icon, int index) {
    final bool isSelected = selectedIndex == index;
    final bool isHovered = hoverIndex == index;

    final TextStyle menuTextStyle = TextStyle(
      color: isSelected ? Colors.white : _withOpacity(Colors.white, 0.85),
      fontSize: 15,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      letterSpacing: 0.3,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => hoverIndex = index),
      onExit: (_) => setState(() => hoverIndex = null),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSelected
                  ? [
                      _withOpacity(const Color(0xFF0A4A8E), 0.5),
                      _withOpacity(const Color(0xFF001529), 0.4),
                    ]
                  : isHovered
                  ? [
                      _withOpacity(const Color(0xFF001529), 0.4),
                      _withOpacity(const Color(0xFF000A1F), 0.3),
                    ]
                  : [
                      _withOpacity(const Color(0xFF000A1F), 0.2),
                      _withOpacity(const Color(0xFF000000), 0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? _withOpacity(const Color(0xFF0A4A8E), 0.6)
                  : isHovered
                  ? _withOpacity(const Color(0xFF0A4A8E), 0.3)
                  : Colors.transparent,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _withOpacity(const Color(0xFF0A4A8E), 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() => selectedIndex = index);
                if (widget.onIndexChanged != null) {
                  widget.onIndexChanged!(index);
                }
              },
              borderRadius: BorderRadius.circular(20),
              splashColor: _withOpacity(const Color(0xFF0A4A8E), 0.2),
              highlightColor: _withOpacity(const Color(0xFF0A4A8E), 0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  _withOpacity(const Color(0xFF0A4A8E), 0.3),
                                  _withOpacity(const Color(0xFF0A4A8E), 0.1),
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Colors.white
                            : _withOpacity(Colors.white, 0.8),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: menuTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _withOpacity(const Color(0xFF0A4A8E), 0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _withOpacity(const Color(0xFF0A4A8E), 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
