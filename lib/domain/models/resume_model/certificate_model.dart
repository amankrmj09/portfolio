import 'package:freezed_annotation/freezed_annotation.dart';

part 'certificate_model.freezed.dart';
part 'certificate_model.g.dart';

@freezed
abstract class CertificateModel with _$CertificateModel {
  const factory CertificateModel({
    required String name,
    required String issuer,
    required String type,
  }) = _CertificateModel;

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      _$CertificateModelFromJson(json);
}
