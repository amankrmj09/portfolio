import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_model.freezed.dart';
part 'education_model.g.dart';

@freezed
abstract class EducationModel with _$EducationModel {
  const factory EducationModel({
    required String institution,
    required String degree,
    required String duration,
    required String location,
  }) = _EducationModel;

  factory EducationModel.fromJson(Map<String, dynamic> json) =>
      _$EducationModelFromJson(json);
}
