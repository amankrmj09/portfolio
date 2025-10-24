// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AchievementModel _$AchievementModelFromJson(Map<String, dynamic> json) =>
    _AchievementModel(
      title: json['title'] as String,
      event: json['event'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$AchievementModelToJson(_AchievementModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'event': instance.event,
      'description': instance.description,
    };
