// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CertificateModel _$CertificateModelFromJson(Map<String, dynamic> json) =>
    _CertificateModel(
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CertificateModelToJson(_CertificateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'issuer': instance.issuer,
      'type': instance.type,
    };
