import 'dart:developer';
import 'package:get/get.dart';
import '../../../../domain/models/export.models.dart';
import '../../../dal/services/export.service.dart';

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

  final quotes = <QuoteModel>[].obs;
  final aboutMeInfo = Rxn<AboutMeInfoModel>();
  final experiences = <ExperienceModel>[].obs;
  final socialLinks = Rxn<SocialLinksModel>();
  final certificates = <CertificateModel>[].obs;
  final projects = <ProjectModel>[].obs;
  final tools = <ToolsModel>[].obs;
  final profiles = <ProfileLinksModel>[].obs;

  Future<void> fetchProfileLinks() async {
    isProjectsLoading.value = true;
    try {
      final service = ProfileLinksFetchService();
      final data = await service.fetchData();
      if (isClosed) return;
      profiles.assignAll(data);
      log(
        'Fetched profile links: ${profiles.length}',
        name: 'ProfileLinksFetchService',
      );
    } catch (e) {
      log(
        'Error fetching profile links: ${e.toString()}',
        name: 'ProfileLinksFetchService',
      );
      profiles.clear();
    } finally {
      isProjectsLoading.value = false;
    }
  }

  Future<void> fetchQuotes() async {
    isQuotesLoading.value = true;
    try {
      final service = QuotesFetchService();
      final data = await service.fetchData();
      if (isClosed) return;
      quotes.assignAll(data);
      log('Fetched quotes: ${quotes.length}', name: 'QuotesFetchService');
    } catch (e) {
      log('Error fetching quotes: ${e.toString()}', name: 'QuotesFetchService');
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
      log('Fetched tools: ${tools.length}', name: 'ToolsFetchService');
    } catch (e) {
      log('Error fetching tools: ${e.toString()}', name: 'ToolsFetchService');
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
      aboutMeInfo.value = links.first as AboutMeInfoModel?;
      log(
        'Fetched about me info: ${aboutMeInfo.value?.name}',
        name: 'AboutMeInfoFetchService',
      );
    } catch (e) {
      log(
        'Error fetching about me info: ${e.toString()}',
        name: 'AboutMeInfoFetchService',
      );
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
      log(
        'Fetched experiences: ${experiences.length}',
        name: 'ExperienceInfoFetchService',
      );
    } catch (e) {
      log(
        'Error fetching experiences: ${e.toString()}',
        name: 'ExperienceInfoFetchService',
      );
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
      socialLinks.value = links.first;
      log(
        'Fetched social links: ${socialLinks.value?.github}',
        name: 'SocialLinksFetchService',
      );
    } catch (e) {
      log(
        'Error fetching social links: ${e.toString()}',
        name: 'SocialLinksFetchService',
      );
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
    } catch (e) {
      log(
        'Error fetching certificates: ${e.toString()}',
        name: 'CertificatesFetchService',
      );
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
    } catch (e) {
      log(
        'Error fetching projects: ${e.toString()}',
        name: 'ProjectsFetchService',
      );
      projects.assignAll([]);
    } finally {
      isProjectsLoading.value = false;
    }
  }

  final Rx<Device> currentDevice = Device.Desktop.obs;

  void updateDevice(double width) {
    if (width < 900) {
      currentDevice.value = Device.Mobile;
    } else if (width < 1300) {
      currentDevice.value = Device.Tablet;
    } else {
      currentDevice.value = Device.Desktop;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileLinks();
    fetchQuotes();
    fetchAboutMeInfo();
    fetchTools();
    fetchExperiences();
    fetchSocialLinks();
    fetchCertificates();
    fetchProjects();
  }
}
