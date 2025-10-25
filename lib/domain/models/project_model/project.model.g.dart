// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) =>
    _ProjectModel(
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      largeDescription: json['largeDescription'] as String,
      techStack: (json['techStack'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ProjectModelToJson(_ProjectModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
      'images': instance.images,
      'largeDescription': instance.largeDescription,
      'techStack': instance.techStack,
      'type': instance.type,
    };
