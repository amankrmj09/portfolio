import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/domain/models/profile_links_model/profile.links.model.dart';
import 'package:portfolio/domain/models/tools_model/tools.model.dart';
import '../../../domain/models/about_me_info_model/about.me.info.model.dart';
import '../../../domain/models/experience_model/experience.model.dart';
import '../../info.fetch.controller.dart';
import '../../home/controllers/home.controller.dart';

class AboutMeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  // Direct getters - no local copies needed
  Rxn<AboutMeInfoModel> get aboutMeInfo => infoFetchController.aboutMeInfo;

  RxList<ToolsModel> get tools => infoFetchController.tools;

  RxList<ExperienceModel> get experiences => infoFetchController.experiences;

  RxList<ProfileLinksModel> get profiles => infoFetchController.profiles;

  RxBool get isLoading => infoFetchController.isAboutMeInfoLoading;

  RxBool get isExpLoading => infoFetchController.isExperienceLoading;

  RxBool get isToolsLoading => infoFetchController.isToolsLoading;

  RxBool get isProfilesLoading => infoFetchController.isProfileLinksLoading;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScrollEdge);
  }

  void _handleScrollEdge() {
    if (!scrollController.hasClients) return;

    final atStart =
        scrollController.offset <= scrollController.position.minScrollExtent;
    final atEnd =
        scrollController.offset >= scrollController.position.maxScrollExtent;

    if (atStart || atEnd) {
      activateHomeControllerScrollbar();
    } else {
      deactivateHomeControllerScrollbar();
    }
  }

  void activateHomeControllerScrollbar() {
    final homeController = Get.find<HomeController>();
    homeController.isScrolling.value = true;
  }

  void deactivateHomeControllerScrollbar() {
    final homeController = Get.find<HomeController>();
    homeController.isScrolling.value = false;
  }

  // Pointer event handlers for scroll/drag forwarding
  void handlePointerSignal(PointerSignalEvent pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      final atStart =
          scrollController.offset <= scrollController.position.minScrollExtent;
      final atEnd =
          scrollController.offset >= scrollController.position.maxScrollExtent;

      if (atStart || atEnd) {
        final homeController = Get.find<HomeController>();
        homeController.scrollController.position.moveTo(
          homeController.scrollController.offset + pointerSignal.scrollDelta.dy,
        );
      }
    }
  }

  void handlePointerMove(PointerMoveEvent pointerEvent) {
    final atStart =
        scrollController.offset <= scrollController.position.minScrollExtent;
    final atEnd =
        scrollController.offset >= scrollController.position.maxScrollExtent;

    if (atStart || atEnd) {
      final homeController = Get.find<HomeController>();
      homeController.scrollController.position.moveTo(
        homeController.scrollController.offset - pointerEvent.delta.dy,
      );
    }
  }

  void handlePointerDown(PointerDownEvent pointerEvent) {
    // Optionally, you can request focus or start drag here
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
