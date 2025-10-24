// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_experience_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkExperienceModel _$WorkExperienceModelFromJson(Map<String, dynamic> json) =>
    _WorkExperienceModel(
      company: json['company'] as String,
      role: json['role'] as String,
      duration: json['duration'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$WorkExperienceModelToJson(
  _WorkExperienceModel instance,
) => <String, dynamic>{
  'company': instance.company,
  'role': instance.role,
  'duration': instance.duration,
  'location': instance.location,
  'description': instance.description,
};
