import 'package:freezed_annotation/freezed_annotation.dart';

import 'achievement_model.dart';
import 'certificate_model.dart';
import 'education_model.dart';
import 'project_model.dart';
import 'work_experience_model.dart';

part 'resume_model.freezed.dart';
part 'resume_model.g.dart';

@freezed
abstract class ResumeModel with _$ResumeModel {
  const factory ResumeModel({
    required List<EducationModel> education,
    required List<WorkExperienceModel> workExperience,
    required List<ProjectModel> projects,
    required List<CertificateModel> certificates,
    required List<AchievementModel> achievements,
  }) = _ResumeModel;

  factory ResumeModel.fromJson(Map<String, dynamic> json) =>
      _$ResumeModelFromJson(json);
}
