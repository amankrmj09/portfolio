import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/domain/models/resume_model/resume_model.dart';
import '../../../domain/models/social_links_model/social.links.model.dart';
import '../../info.fetch.controller.dart';
import '../views/export_views_resume.dart';

class ResumeController extends GetxController {
  final RxList<Map<String, dynamic>> menuData = <Map<String, dynamic>>[
    {
      'index': 0,
      'title': 'Education',
      'icon': Icons.school,
      'screen': EducationView(),
    },
    {
      'index': 1,
      'title': 'Work Experience',
      'icon': Icons.work,
      'screen': WorkExperienceView(),
    },
    {
      'index': 2,
      'title': 'Projects',
      'icon': Icons.code,
      'screen': ProjectsView(),
    },
    {
      'index': 3,
      'title': 'Certificates',
      'icon': Icons.card_membership,
      'screen': CertificatesView(),
    },
    {
      'index': 4,
      'title': 'Achievements',
      'icon': Icons.emoji_events,
      'screen': AchievementsView(),
    },
  ].obs;

  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  // Direct getters - no local copies needed
  RxBool get isLoading => infoFetchController.isResumeLoading;

  Rxn<ResumeModel> get resumeData => infoFetchController.resumeData;

  Rxn<SocialLinksModel> get socialLinks => infoFetchController.socialLinks;
}
