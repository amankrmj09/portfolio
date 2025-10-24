// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResumeModel _$ResumeModelFromJson(Map<String, dynamic> json) => _ResumeModel(
  education: (json['education'] as List<dynamic>)
      .map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  workExperience: (json['workExperience'] as List<dynamic>)
      .map((e) => WorkExperienceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  projects: (json['projects'] as List<dynamic>)
      .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  certificates: (json['certificates'] as List<dynamic>)
      .map((e) => CertificateModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  achievements: (json['achievements'] as List<dynamic>)
      .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ResumeModelToJson(_ResumeModel instance) =>
    <String, dynamic>{
      'education': instance.education,
      'workExperience': instance.workExperience,
      'projects': instance.projects,
      'certificates': instance.certificates,
      'achievements': instance.achievements,
    };
