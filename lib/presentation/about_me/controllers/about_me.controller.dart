import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/domain/models/profile_links_model/profile.links.model.dart';
import 'package:portfolio/domain/models/tools_model/tools.model.dart';
import '../../../domain/models/about_me_info_model/about.me.info.model.dart';
import '../../../domain/models/experience_model/experience.model.dart';
import '../../../infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import '../../home/controllers/home.controller.dart';

class AboutMeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  late var aboutMeInfo = Rxn<AboutMeInfoModel>();
  late var tools = <ToolsModel>[].obs;
  late var experiences = <ExperienceModel>[].obs;
  late var profiles = <ProfileLinksModel>[].obs;

  late var isLoading = true.obs;
  late var isExpLoading = true.obs;
  late var isToolsLoading = true.obs;
  late var isProfilesLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = infoFetchController.isAboutMeInfoLoading.value;
    isExpLoading.value = infoFetchController.isExperienceLoading.value;
    isToolsLoading.value = infoFetchController.isToolsLoading.value;
    isProfilesLoading.value = infoFetchController.isProfileLinksLoading.value;

    aboutMeInfo.value = infoFetchController.aboutMeInfo.value;
    experiences.value = infoFetchController.experiences;
    tools.value = infoFetchController.tools;
    profiles.value = infoFetchController.profiles;

    ever(infoFetchController.isProfileLinksLoading, (val) {
      isProfilesLoading.value = val;
    });
    ever(infoFetchController.profiles, (val) {
      profiles.value = val;
    });
    ever(infoFetchController.isAboutMeInfoLoading, (val) {
      isLoading.value = val;
    });
    ever(infoFetchController.isExperienceLoading, (val) {
      isExpLoading.value = val;
    });
    ever(infoFetchController.isToolsLoading, (val) {
      isToolsLoading.value = val;
    });
    ever(infoFetchController.experiences, (val) {
      experiences.value = val;
    });
    ever(infoFetchController.aboutMeInfo, (val) {
      aboutMeInfo.value = val;
    });
    ever(infoFetchController.tools, (val) {
      tools.value = val;
    });

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
}
