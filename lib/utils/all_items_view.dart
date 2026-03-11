import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../infrastructure/theme/colors.dart';
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
  final Widget Function()? buildShimmerCard;

  const AllItemsView({
    super.key,
    required this.title,
    this.isMobile = false,
    required this.isLoading,
    required this.items,
    required this.titleColor,
    required this.buildDialog,
    required this.buildCard,
    this.buildShimmerCard,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: KColor.darkNavy,
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
                  ? (buildShimmerCard != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: MasonryGridView.count(
                              controller: scrollController,
                              crossAxisCount: isMobile!
                                  ? 1
                                  : getCrossAxisCount(context),
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 18,
                              itemCount: isMobile! ? 3 : 6,
                              itemBuilder: (context, index) =>
                                  buildShimmerCard!(),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: KColor.accentBlue,
                            ),
                          ))
                  : items.isEmpty
                  ? Center(
                      child: Text(
                        'No items found.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
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
                KColor.darkRed.withValues(alpha: 0.5), // Dark red
                KColor.darkerRed.withValues(alpha: 0.4), // Darker red
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: KColor.alertRed.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: KColor.alertRed.withValues(alpha: 0.2),
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
