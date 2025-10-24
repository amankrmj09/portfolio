// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EducationModel _$EducationModelFromJson(Map<String, dynamic> json) =>
    _EducationModel(
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      duration: json['duration'] as String,
      location: json['location'] as String,
    );

Map<String, dynamic> _$EducationModelToJson(_EducationModel instance) =>
    <String, dynamic>{
      'institution': instance.institution,
      'degree': instance.degree,
      'duration': instance.duration,
      'location': instance.location,
    };
