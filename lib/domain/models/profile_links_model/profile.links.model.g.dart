// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.links.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileLinksModel _$ProfileLinksModelFromJson(Map<String, dynamic> json) =>
    _ProfileLinksModel(
      name: json['name'] as String,
      icon: json['icon'] as String,
      url: json['url'] as String,
      color1: json['color1'] as String,
      color2: json['color2'] as String,
    );

Map<String, dynamic> _$ProfileLinksModelToJson(_ProfileLinksModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'url': instance.url,
      'color1': instance.color1,
      'color2': instance.color2,
    };
