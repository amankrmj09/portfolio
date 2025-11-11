import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:portfolio/presentation/info.fetch.controller.dart';

import '../../../domain/models/social_links_model/social.links.model.dart';
import '../../../infrastructure/dal/services/ping.server.dart';

class HomeController extends GetxController {
  late final AnimatedMeshGradientController meshGradientController;

  final ScrollController scrollController = ScrollController();
  final isScrolling = false.obs;
  Timer? _scrollEndDebouncer;
  final RxBool _isProgrammaticScroll =
      false.obs; // Flag to prevent scroll listener interference

  // Public getter for UI to check if scrolling is programmatic
  bool get isProgrammaticScrolling => _isProgrammaticScroll.value;

  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();
  final RxInt selectedTabIndex = 0.obs;

  // Direct getter - no local copy needed
  Rxn<SocialLinksModel> get socialLinks => infoFetchController.socialLinks;

  // Section keys for navigation - converted from static to instance variables
  final GlobalKey recentWorksKey = GlobalKey(debugLabel: 'recentWorksKey');
  final GlobalKey recentCertificatesKey = GlobalKey(
    debugLabel: 'recentCertificatesKey',
  );
  final GlobalKey aboutMeKey = GlobalKey(debugLabel: 'aboutMeKey');
  final GlobalKey homeKey = GlobalKey(debugLabel: 'homeKey');
  final GlobalKey scrollKey = GlobalKey(
    debugLabel: 'scrollKey',
  ); // Key for the scroll view

  // Updated to use instance keys instead of static keys
  late final List<GlobalKey> sectionKeys;
  List<double> _sectionOffsets = []; // To store calculated offsets
  bool _offsetsCalculated = false;

  // Constructor initializes the keys
  // Order must match the floating menu bar labels: Home, About Me, Works, Certificates
  HomeController() {
    sectionKeys = [homeKey, aboutMeKey, recentWorksKey, recentCertificatesKey];
  }

  // Navigation actions: scrolls to section and updates selected tab
  List<VoidCallback> get onTapActions => List.generate(
    sectionKeys.length,
    (index) => () {
      // Set the index immediately to prevent jitter
      selectedTabIndex.value = index;
      _isProgrammaticScroll.value = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = sectionKeys[index].currentContext;
        _logger.i(
          'Navigation button $index clicked. Context found: ${ctx != null}',
        );
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: 0.0,
          ).then((_) {
            // Re-enable scroll listener after animation completes
            Future.delayed(const Duration(milliseconds: 100), () {
              _isProgrammaticScroll.value = false;
            });
          });
        } else {
          _logger.w('Context for section $index is null!');
          _isProgrammaticScroll.value = false;
        }
      });
    },
  );

  @override
  void onInit() {
    super.onInit();
    _pingOnce();

    // No initialization needed - directly using InfoFetchController's observables
    // Removed: socialLinks.value = infoFetchController.socialLinks.value;
    // Removed: ever() listener

    scrollController.addListener(_onScroll);
    meshGradientController = AnimatedMeshGradientController()..start();

    // Calculate offsets after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSectionOffsets();
    });
  }

  final Logger _logger = Logger();

  void _calculateSectionOffsets() {
    final scrollContext = scrollKey.currentContext;
    if (scrollContext == null) return;

    final scrollBox = scrollContext.findRenderObject() as RenderBox;
    final scrollOffsetOnScreen = scrollBox.localToGlobal(Offset.zero).dy;

    _sectionOffsets = sectionKeys.map((key) {
      final ctx = key.currentContext;
      if (ctx == null) return 0.0;
      final box = ctx.findRenderObject() as RenderBox;
      // This calculation gives the widget's layout offset from the top of the screen
      final position = box.localToGlobal(Offset.zero).dy;
      // We subtract the scroll view's own offset to get the correct offset *within* the scrollable content
      return position - scrollOffsetOnScreen;
    }).toList();

    _offsetsCalculated = true;
    _logger.i('Section offsets calculated: $_sectionOffsets');
  }

  Future<void> _pingOnce() async {
    final PingServerService pingServerService = PingServerService();
    try {
      final result = await pingServerService.ping();
      if (result == 'true') {
        _logger.i('Server connected');
      } else {
        _logger.w('Server not connected: $result');
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Exception during server ping',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _onScroll() {
    if (!_offsetsCalculated) {
      // A fallback in case the post-frame callback didn't run for some reason
      _calculateSectionOffsets();
    }

    // Skip setting isScrolling during programmatic scrolling to prevent bar from hiding
    if (!_isProgrammaticScroll.value) {
      if (!isScrolling.value) {
        isScrolling.value = true;
      }
      _scrollEndDebouncer?.cancel();
      _scrollEndDebouncer = Timer(const Duration(milliseconds: 400), () {
        isScrolling.value = false;
      });
    }

    // Skip index updates during programmatic scrolling to prevent jitter
    if (_isProgrammaticScroll.value) {
      return;
    }

    final scrollOffset = scrollController.offset;
    int newIndex = selectedTabIndex.value;

    // Find the index of the last section that is visible
    for (int i = _sectionOffsets.length - 1; i >= 0; i--) {
      if (scrollOffset >= _sectionOffsets[i] - 100) {
        // 100px tolerance
        newIndex = i;
        break;
      }
    }

    if (selectedTabIndex.value != newIndex) {
      selectedTabIndex.value = newIndex;
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _scrollEndDebouncer?.cancel();
    _scrollEndDebouncer = null;
    meshGradientController.dispose();
    super.onClose();
  }
}
