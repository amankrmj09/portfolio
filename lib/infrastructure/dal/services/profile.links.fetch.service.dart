import 'package:portfolio/domain/models/profile_links_model/profile.links.model.dart';
import 'abstract.fetch.service.dart';

class ProfileLinksFetchService extends FetchService<ProfileLinksModel> {
  ProfileLinksFetchService()
    : super('profile.links', (json) => ProfileLinksModel.fromJson(json));
}
