import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:portfolio/infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';

import '../../../domain/models/social_links_model/social.links.model.dart';
import '../../../infrastructure/dal/services/ping.server.dart';

class HomeController extends GetxController {
  late final AnimatedMeshGradientController meshGradientController;

  final ScrollController scrollController = ScrollController();
  final isScrolling = false.obs;
  Timer? _scrollEndDebouncer;

  late var socialLinks = Rxn<SocialLinksModel>();
  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();
  final RxInt selectedTabIndex = 0.obs;

  // Section keys for navigation - converted from static to instance variables
  final GlobalKey recentWorksKey = GlobalKey(debugLabel: 'recentWorksKey');
  final GlobalKey recentCertificatesKey = GlobalKey(
    debugLabel: 'recentCertificatesKey',
  );
  final GlobalKey aboutMeKey = GlobalKey(debugLabel: 'aboutMeKey');
  final GlobalKey homeKey = GlobalKey(debugLabel: 'homeKey');

  // Updated to use instance keys instead of static keys
  late final List<GlobalKey> sectionKeys;

  // Constructor initializes the keys
  HomeController() {
    sectionKeys = [homeKey, recentWorksKey, recentCertificatesKey, aboutMeKey];
  }

  // Navigation actions: scrolls to section and updates selected tab
  List<VoidCallback> get onTapActions => List.generate(
    sectionKeys.length,
    (index) => () {
      final ctx = sectionKeys[index].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
        selectedTabIndex.value = index;
      }
    },
  );

  @override
  void onInit() {
    super.onInit();
    _pingOnce();
    // isLoading.value = infoFetchController.isProjectsLoading.value;
    socialLinks.value = infoFetchController.socialLinks.value;
    // ever(infoFetchController.isSocialLinksLoading, (val) {
    //   isLoading.value = val;
    // });
    ever(infoFetchController.socialLinks, (val) {
      socialLinks.value = val;
    });

    scrollController.addListener(_onScroll);
    meshGradientController = AnimatedMeshGradientController()..start();
  }

  final Logger _logger = Logger();

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
    if (!isScrolling.value) {
      isScrolling.value = true;
    }
    _scrollEndDebouncer?.cancel();
    _scrollEndDebouncer = Timer(const Duration(milliseconds: 400), () {
      isScrolling.value = false;
    });

    // Get the scroll position
    final scrollOffset = scrollController.offset;
    int newIndex = 0;
    for (int i = 0; i < sectionKeys.length; i++) {
      final ctx = sectionKeys[i].currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox;
        final position =
            box.localToGlobal(Offset.zero, ancestor: null).dy +
            scrollController.offset;
        // If the scroll offset is past this section, update the index
        if (scrollOffset >= position - 100) {
          newIndex = i;
        }
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
