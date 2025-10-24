// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) =>
    _ProjectModel(
      name: json['name'] as String,
      techStack: (json['techStack'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      duration: json['duration'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ProjectModelToJson(_ProjectModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'techStack': instance.techStack,
      'duration': instance.duration,
      'description': instance.description,
    };
