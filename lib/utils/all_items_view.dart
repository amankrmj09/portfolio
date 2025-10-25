import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'axis.count.dart';
import 'k.showGeneralDialog.dart';

class AllItemsView<T> extends StatelessWidget {
  final String title;
  final bool isLoading;
  final List<T> items;
  final Color titleColor;
  final bool? isMobile;
  final Widget Function(T item) buildDialog;
  final Widget Function(T item, VoidCallback onTap) buildCard;

  const AllItemsView({
    super.key,
    required this.title,
    this.isMobile = false,
    required this.isLoading,
    required this.items,
    required this.titleColor,
    required this.buildDialog,
    required this.buildCard,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      extendBodyBehindAppBar: true, // ✅ Makes body go behind app bar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _buildFloatingAppBar(context),
      ),
      body: SafeArea(
        top: false, // ✅ Don't apply safe area to top (app bar floats over)
        child: Stack(
          children: [
            // Content
            Padding(
              padding: const EdgeInsets.only(top: 70),
              // ✅ Space for floating app bar
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFF0A4A8E),
                      ),
                    )
                  : items.isEmpty
                  ? Center(
                      child: Text(
                        'No items found.',
                        style: TextStyle(
                          color: Colors.white.withAlpha((0.7 * 255).toInt()),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  : ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad,
                        },
                        overscroll: false,
                      ),
                      child: MasonryGridView.count(
                        controller: scrollController,
                        crossAxisCount: getCrossAxisCount(context),
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return buildCard(
                            item,
                            () => showBlurredGeneralDialog(
                              context: context,
                              builder: (context) => buildDialog(item),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingAppBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      height: 70,
      decoration: BoxDecoration(
        // ✅ Glassmorphic gradient
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0A1628).withValues(alpha: 0.85),
            const Color(0xFF001529).withValues(alpha: 0.75),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0A4A8E).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF0A4A8E).withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // ✅ Blur effect
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Modern Red-Blackish Back Button
                _buildModernBackButton(context),
                const SizedBox(width: 16),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontFamily: "ShantellSans",
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile! ? 20 : 28,
                      letterSpacing: 0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Spacer to balance the back button
                const SizedBox(width: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernBackButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF8B0000).withValues(alpha: 0.5), // Dark red
                const Color(0xFF4B0000).withValues(alpha: 0.4), // Darker red
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFFF4444).withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4444).withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white.withValues(alpha: 0.95),
            size: 22,
          ),
        ),
      ),
    );
  }
}
