import 'package:portfolio/infrastructure/dal/services/abstract.fetch.service.dart';

import '../../../domain/models/resume_model/resume_model.dart';

class ResumeFetchService extends FetchService<ResumeModel> {
  ResumeFetchService() : super('resume', (json) => ResumeModel.fromJson(json));
}
