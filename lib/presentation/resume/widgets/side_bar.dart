import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBar extends StatefulWidget {
  final ValueChanged<int>? onIndexChanged;
  final List<Map<String, dynamic>> menuData;

  const SideBar({super.key, this.onIndexChanged, required this.menuData});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedIndex = 0;
  int? hoverIndex;
  bool isBackButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0A1628).withOpacity(0.85),
            const Color(0xFF000108).withOpacity(0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
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
          // ✅ Header with Resume title and Back button
          _buildHeader(),
          const SizedBox(height: 24),

          // Menu items
          for (int i = 0; i < widget.menuData.length; i++)
            buildMenuButton(
              widget.menuData[i]['title'] as String,
              widget.menuData[i]['icon'] as IconData,
              i,
            ),
        ],
      ),
    );
  }

  // ✅ Header with Resume title and back button
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
                    const Color(
                      0xFF8B0000,
                    ).withOpacity(0.4), // Deep red on hover
                    const Color(0xFF4B0000).withOpacity(0.3),
                  ]
                : [
                    const Color(
                      0xFF6B0000,
                    ).withOpacity(0.3), // Dark red default
                    const Color(0xFF3B0000).withOpacity(0.2),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isBackButtonHovered
                ? const Color(0xFFFF4444).withOpacity(0.4)
                : const Color(0xFF8B0000).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isBackButtonHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF4444).withOpacity(0.2),
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
              Get.back(); // ✅ GetX back navigation
            },
            borderRadius: BorderRadius.circular(20),
            // splashColor: const Color(0xFFFF4444).withOpacity(0.2),
            // highlightColor: const Color(0xFFFF4444).withOpacity(0.1),
            hoverColor: Colors.transparent,
            child: Row(
              children: [
                // Back icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF4444).withOpacity(0.3),
                        const Color(0xFFFF4444).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white.withOpacity(0.95),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Resume text
                Expanded(
                  child: Text(
                    'RESUME',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                // Indicator
                // if (isBackButtonHovered)
                //   Icon(
                //     Icons.keyboard_arrow_left_rounded,
                //     color: Colors.white.withOpacity(0.8),
                //     size: 20,
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(String title, IconData icon, int index) {
    final bool isSelected = selectedIndex == index;
    final bool isHovered = hoverIndex == index;

    final TextStyle menuTextStyle = TextStyle(
      color: isSelected ? Colors.white : Colors.white.withOpacity(0.85),
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
                      const Color(0xFF0A4A8E).withOpacity(0.5),
                      const Color(0xFF001529).withOpacity(0.4),
                    ]
                  : isHovered
                  ? [
                      const Color(0xFF001529).withOpacity(0.4),
                      const Color(0xFF000A1F).withOpacity(0.3),
                    ]
                  : [
                      const Color(0xFF000A1F).withOpacity(0.2),
                      const Color(0xFF000000).withOpacity(0.1),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0A4A8E).withOpacity(0.6)
                  : isHovered
                  ? const Color(0xFF0A4A8E).withOpacity(0.3)
                  : Colors.transparent,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF0A4A8E).withOpacity(0.3),
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
              splashColor: const Color(0xFF0A4A8E).withOpacity(0.2),
              highlightColor: const Color(0xFF0A4A8E).withOpacity(0.1),
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
                                  const Color(0xFF0A4A8E).withOpacity(0.3),
                                  const Color(0xFF0A4A8E).withOpacity(0.1),
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.8),
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
                          color: const Color(0xFF0A4A8E).withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0A4A8E).withOpacity(0.5),
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
