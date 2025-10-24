import 'dart:developer';

import 'package:get/get.dart';
import 'package:portfolio/domain/models/resume_model/resume_model.dart';

import '../../../../domain/models/export.models.dart';
import '../../../dal/services/export.service.dart';
import '../../../dal/services/resume.fetch.service.dart';

// ignore: constant_identifier_names
enum Device { Desktop, Tablet, Mobile }

class InfoFetchController extends GetxController {
  final isQuotesLoading = true.obs;
  final isAboutMeInfoLoading = true.obs;
  final isExperienceLoading = true.obs;
  final isSocialLinksLoading = true.obs;
  final isCertificatesLoading = true.obs;
  final isProjectsLoading = true.obs;
  final isToolsLoading = true.obs;
  final isProfileLinksLoading = true.obs;
  final isResumeLoading = true.obs;

  final quotes = <QuoteModel>[].obs;
  final aboutMeInfo = Rxn<AboutMeInfoModel>();
  final experiences = <ExperienceModel>[].obs;
  final socialLinks = Rxn<SocialLinksModel>();
  final certificates = <CertificateModel>[].obs;
  final projects = <ProjectModel>[].obs;
  final tools = <ToolsModel>[].obs;
  final profiles = <ProfileLinksModel>[].obs;
  final resumeData = Rxn<ResumeModel>();

  Future<void> fetchResumeInfo() async {
    isResumeLoading.value = true;
    try {
      final service = ResumeFetchService();
      final data = await service.fetchData();
      log('${data.length}', name: 'ResumeFetchService');
      if (isClosed) return;
      resumeData.value = data.isNotEmpty ? data.first as ResumeModel? : null;
    } catch (e) {
      log('0', name: 'ResumeFetchService');
    } finally {
      isResumeLoading.value = false;
    }
  }

  Future<void> fetchProfileLinks() async {
    isProfileLinksLoading.value = true;
    try {
      final service = ProfileLinksFetchService();
      final data = await service.fetchData();
      if (isClosed) return;
      profiles.assignAll(data);
      log('${profiles.length}', name: 'ProfileLinksFetchService');
    } catch (e) {
      log('0', name: 'ProfileLinksFetchService');
      profiles.clear();
    } finally {
      isProfileLinksLoading.value = false;
    }
  }

  Future<void> fetchQuotes() async {
    isQuotesLoading.value = true;
    try {
      final service = QuotesFetchService();
      final data = await service.fetchData();
      if (isClosed) return;
      quotes.assignAll(data);
      log('${quotes.length}', name: 'QuotesFetchService');
    } catch (e) {
      log('0', name: 'QuotesFetchService');
      quotes.clear();
    } finally {
      isQuotesLoading.value = false;
    }
  }

  Future<void> fetchTools() async {
    isToolsLoading.value = true;
    try {
      final service = ToolsFetchService();
      final data = await service.fetchData();
      if (isClosed) return;
      tools.assignAll(data);
      log('${tools.length}', name: 'ToolsFetchService');
    } catch (e) {
      log('0', name: 'ToolsFetchService');
      tools.clear();
    } finally {
      isToolsLoading.value = false;
    }
  }

  Future<void> fetchAboutMeInfo() async {
    isAboutMeInfoLoading.value = true;
    try {
      final service = AboutMeInfoFetchService();
      final links = await service.fetchData();
      if (isClosed) return;
      aboutMeInfo.value = links.isNotEmpty
          ? links.first as AboutMeInfoModel?
          : null;
      log('${links.length}', name: 'AboutMeInfoFetchService');
    } catch (e) {
      log('0', name: 'AboutMeInfoFetchService');
    } finally {
      isAboutMeInfoLoading.value = false;
    }
  }

  Future<void> fetchExperiences() async {
    isExperienceLoading.value = true;
    try {
      final service = ExperienceInfoFetchService();
      final data = await service.fetchData();
      if (isClosed) return;
      experiences.assignAll(data);
      log('${experiences.length}', name: 'ExperienceInfoFetchService');
    } catch (e) {
      log('0', name: 'ExperienceInfoFetchService');
      experiences.assignAll([]);
    } finally {
      isExperienceLoading.value = false;
    }
  }

  Future<void> fetchSocialLinks() async {
    isSocialLinksLoading.value = true;
    try {
      final service = SocialLinksFetchService();
      final links = await service.fetchData();
      if (isClosed) return;
      socialLinks.value = links.isNotEmpty ? links.first : null;
      log('${links.length}', name: 'SocialLinksFetchService');
    } catch (e) {
      log('0', name: 'SocialLinksFetchService');
      socialLinks.value = SocialLinksModel(
        github: '',
        linkedIn: '',
        twitter: '',
        instagram: '',
        facebook: '',
        medium: '',
        email: '',
        resume: '',
        discord: '',
        phoneNumber: '',
        hackerrank: '',
        leetcode: '',
      );
    } finally {
      isSocialLinksLoading.value = false;
    }
  }

  Future<void> fetchCertificates() async {
    isCertificatesLoading.value = true;
    try {
      final service = CertificatesFetchService();
      final data = await service.fetchData();
      certificates.assignAll(data);
      log('${certificates.length}', name: 'CertificatesFetchService');
    } catch (e) {
      log('0', name: 'CertificatesFetchService');
      certificates.assignAll([]);
    } finally {
      isCertificatesLoading.value = false;
    }
  }

  Future<void> fetchProjects() async {
    isProjectsLoading.value = true;
    try {
      final service = ProjectsFetchService();
      final data = await service.fetchData();
      projects.assignAll(data);
      log('${projects.length}', name: 'ProjectsFetchService');
    } catch (e) {
      log('0', name: 'ProjectsFetchService');
      projects.assignAll([]);
    } finally {
      isProjectsLoading.value = false;
    }
  }

  final Rx<Device> currentDevice = Device.Desktop.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    fetchSocialLinks();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchCertificates();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchProjects();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchProfileLinks();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchQuotes();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchAboutMeInfo();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchTools();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchExperiences();
    await Future.delayed(const Duration(milliseconds: 200));
    fetchResumeInfo();
  }
}
